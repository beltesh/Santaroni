import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';

import '../util/email.dart';
import 'wishlist_parser.dart';

/// One participant read from a CSV file.
class CsvParticipant {
  const CsvParticipant({
    required this.rowNumber,
    required this.name,
    required this.email,
    this.group,
    this.wishlist = const [],
  });

  /// Spreadsheet row number (the header is row 1).
  final int rowNumber;
  final String name;
  final String email;
  final String? group;
  final List<WishlistEntry> wishlist;
}

enum CsvRowProblem { missingName, missingEmail, invalidEmail, duplicateEmail }

class CsvRowError {
  const CsvRowError(this.rowNumber, this.problem, {this.value});

  final int rowNumber;
  final CsvRowProblem problem;

  /// The offending value, e.g. the invalid email address.
  final String? value;
}

enum CsvColumn { name, email, wishlist, group }

class ParticipantCsvResult {
  const ParticipantCsvResult({
    required this.participants,
    required this.errors,
    required this.missingColumns,
  });

  /// Rows that can be imported.
  final List<CsvParticipant> participants;

  /// Rows that were skipped, with the reason.
  final List<CsvRowError> errors;

  /// Required columns not found in the header. When non-empty, nothing was
  /// parsed.
  final Set<CsvColumn> missingColumns;

  bool get isUsable => missingColumns.isEmpty && participants.isNotEmpty;
}

/// Header names accepted for each column, compared after lowercasing and
/// removing accents, spaces and punctuation. Covers English and Spanish, and
/// the default Google Forms headers ("Email Address", "Dirección de correo
/// electrónico").
const _aliases = <CsvColumn, Set<String>>{
  CsvColumn.name: {
    'name', 'fullname', 'yourname', 'participant', //
    'nombre', 'nombrecompleto', 'tunombre', 'participante',
  },
  CsvColumn.email: {
    'email', 'emailaddress', 'mail', 'youremail', //
    'correo', 'correoelectronico', 'direcciondecorreo',
    'direcciondecorreoelectronico', 'tucorreo',
  },
  CsvColumn.wishlist: {
    'wishlist', 'wishes', 'wish', 'gifts', 'giftideas', 'ideas', //
    'listadedeseos', 'deseos', 'regalos', 'ideasderegalo',
  },
  CsvColumn.group: {
    'group', 'household', 'exclude', 'exclusiongroup', //
    'grupo', 'familia', 'hogar',
  },
};

/// Parses a participants CSV file.
///
/// Accepts UTF-8 (with or without BOM) and falls back to Latin-1 for files
/// saved by older versions of Excel. Comma, semicolon and tab delimiters are
/// detected automatically.
abstract final class ParticipantCsv {
  static final _decoder = Csv(skipEmptyLines: false);

  /// Email addresses already in the event, so duplicates can be reported.
  static ParticipantCsvResult parseBytes(
    Uint8List bytes, {
    Set<String> existingEmails = const {},
  }) => parse(decodeText(bytes), existingEmails: existingEmails);

  static String decodeText(Uint8List bytes) {
    try {
      return utf8.decode(bytes);
    } on FormatException {
      return latin1.decode(bytes);
    }
  }

  static ParticipantCsvResult parse(
    String text, {
    Set<String> existingEmails = const {},
  }) {
    if (text.startsWith('﻿')) text = text.substring(1); // UTF-8 BOM.

    // Keep blank rows so indexes match spreadsheet row numbers in errors.
    final rows = _decoder
        .decode(text)
        .map((row) => row.map((cell) => cell?.toString() ?? '').toList())
        .toList();
    if (rows.isEmpty) {
      return const ParticipantCsvResult(
        participants: [],
        errors: [],
        missingColumns: {CsvColumn.name, CsvColumn.email},
      );
    }

    final columns = _mapHeader(rows.first);
    final missing = {
      CsvColumn.name,
      CsvColumn.email,
    }.where((c) => !columns.containsKey(c)).toSet();
    if (missing.isNotEmpty) {
      return ParticipantCsvResult(
        participants: const [],
        errors: const [],
        missingColumns: missing,
      );
    }

    String cell(List<String> row, CsvColumn column) {
      final index = columns[column];
      if (index == null || index >= row.length) return '';
      return row[index].trim();
    }

    final participants = <CsvParticipant>[];
    final errors = <CsvRowError>[];
    final seen = existingEmails.map(normalizeEmail).toSet();

    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      final rowNumber = i + 1;
      if (row.every((c) => c.trim().isEmpty)) continue;

      final name = cell(row, CsvColumn.name);
      final email = cell(row, CsvColumn.email);

      if (name.isEmpty) {
        errors.add(CsvRowError(rowNumber, CsvRowProblem.missingName));
        continue;
      }
      if (email.isEmpty) {
        errors.add(
          CsvRowError(rowNumber, CsvRowProblem.missingEmail, value: name),
        );
        continue;
      }
      if (!isValidEmail(email)) {
        errors.add(
          CsvRowError(rowNumber, CsvRowProblem.invalidEmail, value: email),
        );
        continue;
      }
      if (!seen.add(normalizeEmail(email))) {
        errors.add(
          CsvRowError(rowNumber, CsvRowProblem.duplicateEmail, value: email),
        );
        continue;
      }

      final group = cell(row, CsvColumn.group);
      participants.add(
        CsvParticipant(
          rowNumber: rowNumber,
          name: name,
          email: email,
          group: group.isEmpty ? null : group,
          wishlist: parseWishlist(cell(row, CsvColumn.wishlist)),
        ),
      );
    }

    return ParticipantCsvResult(
      participants: participants,
      errors: errors,
      missingColumns: const {},
    );
  }

  static Map<CsvColumn, int> _mapHeader(List<String> header) {
    final result = <CsvColumn, int>{};
    for (var i = 0; i < header.length; i++) {
      final key = _headerKey(header[i]);
      for (final MapEntry(key: column, value: names) in _aliases.entries) {
        if (!result.containsKey(column) && names.contains(key)) {
          result[column] = i;
        }
      }
    }
    return result;
  }

  static String _headerKey(String header) {
    const accents = {
      'á': 'a', 'é': 'e', 'í': 'i', 'ó': 'o', 'ú': 'u', //
      'ü': 'u', 'ñ': 'n',
    };
    final lower = header.trim().toLowerCase();
    final buffer = StringBuffer();
    for (final char in lower.split('')) {
      buffer.write(accents[char] ?? char);
    }
    return buffer.toString().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }
}
