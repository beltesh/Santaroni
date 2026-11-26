import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:santaroni/core/import/participant_csv.dart';
import 'package:santaroni/core/import/wishlist_parser.dart';

void main() {
  group('parseWishlist', () {
    test('splits on newlines and pipes, and extracts trailing links', () {
      expect(
        parseWishlist(
          'Saga Vol. 1 https://example.com/saga\n'
          'Any Moebius artbook\r\n'
          'Gift card | Sandman Deluxe - https://example.com/sandman',
        ),
        [
          const WishlistEntry('Saga Vol. 1', 'https://example.com/saga'),
          const WishlistEntry('Any Moebius artbook'),
          const WishlistEntry('Gift card'),
          const WishlistEntry('Sandman Deluxe', 'https://example.com/sandman'),
        ],
      );
    });

    test('uses a bare link as its own text and adds https to www links', () {
      expect(parseWishlist('https://example.com/x'), [
        const WishlistEntry('https://example.com/x', 'https://example.com/x'),
      ]);
      expect(parseWishlist('Mug www.example.com/mug'), [
        const WishlistEntry('Mug', 'https://www.example.com/mug'),
      ]);
    });

    test('keeps links in the middle of the text as text', () {
      expect(parseWishlist('Something from https://example.com, any size'), [
        const WishlistEntry('Something from https://example.com, any size'),
      ]);
    });

    test('ignores blank items', () {
      expect(parseWishlist('  \n\n | '), isEmpty);
    });
  });

  group('ParticipantCsv', () {
    test('parses the documented format', () {
      const text =
          'name,email,wishlist,group\n'
          'Alice,alice@example.com,"Saga Vol. 1 https://example.com/saga\n'
          'Any Moebius artbook",smith\n'
          'Bob,bob@example.com,,smith\n'
          'Carol,carol@example.com,"Gift card | Sandman Deluxe https://example.com/sandman",\n';
      final result = ParticipantCsv.parse(text);

      expect(result.missingColumns, isEmpty);
      expect(result.errors, isEmpty);
      expect(result.participants.map((p) => p.name), ['Alice', 'Bob', 'Carol']);
      expect(result.participants[0].wishlist, hasLength(2));
      expect(result.participants[0].group, 'smith');
      expect(result.participants[1].wishlist, isEmpty);
      expect(result.participants[2].group, isNull);
      expect(
        result.participants[2].wishlist.last.url,
        'https://example.com/sandman',
      );
    });

    test('maps Portuguese headers, including Google Forms in Portuguese', () {
      const text =
          'Carimbo de data/hora,Endereço de e-mail,Seu nome,Lista de desejos,Família\n'
          '01/11/2026 10:00,joao@example.com,João,"Livro\nMeias",souza\n';
      final result = ParticipantCsv.parse(text);
      expect(result.missingColumns, isEmpty);
      final p = result.participants.single;
      expect((p.name, p.email, p.group), ('João', 'joao@example.com', 'souza'));
      expect(p.wishlist.map((w) => w.text), ['Livro', 'Meias']);

      final simple = ParticipantCsv.parse('nome;e-mail;desejos;grupo\nAna;ana@example.com;;\n');
      expect(simple.participants.single.name, 'Ana');
    });

    test('handles semicolons, BOM, CRLF and Spanish headers', () {
      const text =
          '﻿Nombre;Correo electrónico;Lista de deseos;Grupo\r\n'
          'José;jose@example.com;Libro;\r\n'
          'María;maria@example.com;;casa\r\n';
      final result = ParticipantCsv.parse(text);
      expect(result.missingColumns, isEmpty);
      expect(result.participants.map((p) => p.name), ['José', 'María']);
      expect(result.participants[1].group, 'casa');
    });

    test('maps Google Forms headers and ignores extra columns', () {
      const text =
          'Timestamp,Email Address,Your name,Gift ideas\n'
          '2026/11/01 10:00,ana@example.com,Ana,Socks\n';
      final result = ParticipantCsv.parse(text);
      expect(result.participants.single.name, 'Ana');
      expect(result.participants.single.email, 'ana@example.com');
      expect(result.participants.single.wishlist.single.text, 'Socks');
    });

    test('reports missing required columns', () {
      final result = ParticipantCsv.parse('name,phone\nAna,555\n');
      expect(result.missingColumns, {CsvColumn.email});
      expect(result.isUsable, isFalse);
    });

    test('reports bad rows with spreadsheet row numbers and skips blanks', () {
      const text =
          'name,email\n'
          'Ana,ana@example.com\n'
          ',nobody@example.com\n'
          'Beto,\n'
          'Carla,not-an-email\n'
          ',\n'
          'Dani,ANA@example.com\n'
          'Eva,existing@example.com\n';
      final result = ParticipantCsv.parse(
        text,
        existingEmails: {'Existing@Example.com'},
      );
      expect(result.participants.map((p) => p.name), ['Ana']);
      expect(result.errors.map((e) => (e.rowNumber, e.problem)), [
        (3, CsvRowProblem.missingName),
        (4, CsvRowProblem.missingEmail),
        (5, CsvRowProblem.invalidEmail),
        (7, CsvRowProblem.duplicateEmail),
        (8, CsvRowProblem.duplicateEmail),
      ]);
    });

    test('falls back to Latin-1 for non-UTF-8 files', () {
      final bytes = Uint8List.fromList(
        latin1.encode('name,email\nJosé,jose@example.com\n'),
      );
      final result = ParticipantCsv.parseBytes(bytes);
      expect(result.participants.single.name, 'José');
    });

    test('empty file reports missing columns', () {
      expect(ParticipantCsv.parse('').missingColumns, isNotEmpty);
    });
  });
}
