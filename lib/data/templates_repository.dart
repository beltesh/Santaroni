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
  TemplateProblem? get problem => checkBody(bodyTemplate, kind: kind);
}

/// The subject and body an event's emails use.
class EventEmailTemplate {
  const EventEmailTemplate({
    required this.subject,
    required this.body,
    this.custom,
    this.kind = TemplateKind.assignment,
  });

  final String subject;
  final BodyTemplate body;

  /// The imported template, or null for the built-in one.
  final EmailTemplate? custom;

  final TemplateKind kind;

  /// Why these emails can't be sent yet, or null when everything is fine.
  TemplateProblem? get problem =>
      checkSubject(subject, kind: kind) ?? checkBody(body, kind: kind);
}

class UnsupportedTemplateFileException implements Exception {
  const UnsupportedTemplateFileException(this.fileName);
  final String fileName;
}

/// Email body templates imported from `.txt` or `.html` files.
class TemplatesRepository {
  TemplatesRepository(this._db);

  final AppDatabase _db;

  /// Imported templates of every kind, by name.
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
  Future<EmailTemplate> importFile(
    String fileName,
    Uint8List bytes, {
    TemplateKind kind = TemplateKind.assignment,
  }) async {
    final id = await _db
        .into(_db.emailTemplates)
        .insert(
          EmailTemplatesCompanion.insert(
            name: p.basenameWithoutExtension(fileName),
            fileName: fileName,
            format: _formatFor(fileName),
            body: _decode(bytes),
            kind: Value(kind),
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

  /// The assignment email for [event].
  Future<EventEmailTemplate> forEvent(Event event) => resolve(
    TemplateKind.assignment,
    languageCode: event.languageCode,
    templateId: event.templateId,
    subject: event.emailSubject,
  );

  /// The cancellation email chosen when [event] was cancelled.
  Future<EventEmailTemplate> forCancellation(Event event) => resolve(
    TemplateKind.cancellation,
    languageCode: event.languageCode,
    templateId: event.cancelTemplateId,
    subject: event.cancelSubject,
  );

  /// A [kind] of email: the imported template [templateId] (falling back
  /// to the built-in one when it's null or was deleted) and [subject] (or
  /// the default one in [languageCode]).
  Future<EventEmailTemplate> resolve(
    TemplateKind kind, {
    required String languageCode,
    int? templateId,
    String? subject,
  }) async {
    final s = subject == null || subject.trim().isEmpty
        ? defaultSubjectFor(kind, languageCode)
        : subject;
    if (templateId != null) {
      final custom = await watchTemplate(templateId).first;
      if (custom != null) {
        return EventEmailTemplate(
          subject: s,
          body: custom.bodyTemplate,
          custom: custom,
          kind: kind,
        );
      }
    }
    return EventEmailTemplate(
      subject: s,
      body: builtinBodyFor(kind, languageCode),
      kind: kind,
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
