import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../core/email/builtin_templates.dart';
import '../core/email/email_renderer.dart';
import 'database.dart';

const templateFileExtensions = ['txt', 'html', 'htm'];

extension EmailTemplateBody on EmailTemplate {
  BodyTemplate get bodyTemplate => BodyTemplate(
    format == TemplateFormat.html ? BodyFormat.html : BodyFormat.text,
    body,
  );

  /// Why this template can't be used to send, or null when it's fine.
  TemplateProblem? get problem => checkBody(bodyTemplate);
}

/// The subject and body an event's emails use.
class EventEmailTemplate {
  const EventEmailTemplate({
    required this.subject,
    required this.body,
    this.custom,
  });

  final String subject;
  final BodyTemplate body;

  /// The imported template, or null for the built-in one.
  final EmailTemplate? custom;

  /// Why these emails can't be sent yet, or null when everything is fine.
  TemplateProblem? get problem => checkSubject(subject) ?? checkBody(body);
}

class UnsupportedTemplateFileException implements Exception {
  const UnsupportedTemplateFileException(this.fileName);
  final String fileName;
}

/// Email body templates imported from `.txt` or `.html` files.
class TemplatesRepository {
  TemplatesRepository(this._db);

  final AppDatabase _db;

  Stream<List<EmailTemplate>> watchTemplates() =>
      (_db.select(
            _db.emailTemplates,
          )..orderBy([(t) => OrderingTerm.asc(t.name.collate(Collate.noCase))]))
          .watch();

  Stream<EmailTemplate?> watchTemplate(int id) => (_db.select(
    _db.emailTemplates,
  )..where((t) => t.id.equals(id))).watchSingleOrNull();

  /// Saves a copy of a template file. Templates with problems are still
  /// saved, so the user can see what's wrong, but can't be used to send
  /// until replaced with a fixed file.
  Future<EmailTemplate> importFile(String fileName, Uint8List bytes) async {
    final id = await _db
        .into(_db.emailTemplates)
        .insert(
          EmailTemplatesCompanion.insert(
            name: p.basenameWithoutExtension(fileName),
            fileName: fileName,
            format: _formatFor(fileName),
            body: _decode(bytes),
          ),
        );
    return (await watchTemplate(id).first)!;
  }

  /// Replaces a template's contents with a new (usually corrected) file,
  /// keeping its name and the events that use it.
  Future<EmailTemplate> replaceFile(
    int id,
    String fileName,
    Uint8List bytes,
  ) async {
    await (_db.update(_db.emailTemplates)..where((t) => t.id.equals(id))).write(
      EmailTemplatesCompanion(
        fileName: Value(fileName),
        format: Value(_formatFor(fileName)),
        body: Value(_decode(bytes)),
        importedAt: Value(DateTime.now()),
      ),
    );
    return (await watchTemplate(id).first)!;
  }

  /// Events using this template go back to the built-in one.
  Future<void> delete(int id) =>
      (_db.delete(_db.emailTemplates)..where((t) => t.id.equals(id))).go();

  Future<EventEmailTemplate> forEvent(Event event) async {
    final subject = event.emailSubject ?? defaultSubject(event.languageCode);
    final id = event.templateId;
    if (id != null) {
      final custom = await watchTemplate(id).first;
      if (custom != null) {
        return EventEmailTemplate(
          subject: subject,
          body: custom.bodyTemplate,
          custom: custom,
        );
      }
    }
    return EventEmailTemplate(
      subject: subject,
      body: builtinBody(event.languageCode),
    );
  }

  static TemplateFormat _formatFor(String fileName) {
    final ext = p.extension(fileName).toLowerCase().replaceFirst('.', '');
    if (!templateFileExtensions.contains(ext)) {
      throw UnsupportedTemplateFileException(fileName);
    }
    return ext == 'txt' ? TemplateFormat.text : TemplateFormat.html;
  }

  static String _decode(Uint8List bytes) {
    String text;
    try {
      text = utf8.decode(bytes);
    } on FormatException {
      text = latin1.decode(bytes);
    }
    return text.startsWith('﻿') ? text.substring(1) : text; // BOM.
  }
}
