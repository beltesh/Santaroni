import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santaroni/core/email/builtin_templates.dart';
import 'package:santaroni/core/email/email_renderer.dart';
import 'package:santaroni/data/database.dart';
import 'package:santaroni/data/events_repository.dart';
import 'package:santaroni/data/templates_repository.dart';
import 'package:sqlite3/sqlite3.dart';

Uint8List bytes(String s) => Uint8List.fromList(utf8.encode(s));

void main() {
  late AppDatabase db;
  late TemplatesRepository templates;
  late EventsRepository events;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    templates = TemplatesRepository(db);
    events = EventsRepository(db);
  });
  tearDown(() => db.close());

  Future<Event> event(int id) async => (await events.watchEvent(id).first)!;

  test('events default to the built-in HTML template and subject', () async {
    final en = await events.createEvent(const EventDraft(name: 'A'));
    final es = await events.createEvent(
      const EventDraft(name: 'B', languageCode: 'es'),
    );

    final enTemplate = await templates.forEvent(await event(en));
    expect(enTemplate.subject, defaultSubject('en'));
    expect(enTemplate.body.format, BodyFormat.html);
    expect(enTemplate.custom, isNull);
    expect(enTemplate.problem, isNull);
    expect(
      (await templates.forEvent(await event(es))).subject,
      defaultSubject('es'),
    );
  });

  test(
    'a custom subject is stored, and a blank one means the default',
    () async {
      final id = await events.createEvent(
        const EventDraft(name: 'A', emailSubject: '  Shh, {{GiverName}}  '),
      );
      expect((await event(id)).emailSubject, 'Shh, {{GiverName}}');

      await events.updateEvent(
        id,
        const EventDraft(name: 'A', emailSubject: '   '),
      );
      expect((await event(id)).emailSubject, isNull);
      expect(
        (await templates.forEvent(await event(id))).subject,
        defaultSubject('en'),
      );
    },
  );

  test('imports text and HTML files by extension', () async {
    final txt = await templates.importFile(
      'My Note.txt',
      bytes('Hi {{GiverName}}'),
    );
    expect(txt.name, 'My Note');
    expect(txt.format, TemplateFormat.text);
    expect(txt.problem, isNull);

    final html = await templates.importFile(
      'fancy.HTML',
      bytes('﻿<p>{{RecipientName}}</p>'),
    );
    expect(html.format, TemplateFormat.html);
    expect(html.body, '<p>{{RecipientName}}</p>', reason: 'BOM removed');

    expect(
      () => templates.importFile('logo.png', bytes('x')),
      throwsA(isA<UnsupportedTemplateFileException>()),
    );
    expect(await templates.watchTemplates().first, hasLength(2));
  });

  test(
    'broken templates are saved but flagged, and replacing fixes them',
    () async {
      final t = await templates.importFile(
        't.html',
        bytes('<p>{{RecipientNmae}}</p>'),
      );
      expect(t.problem?.unknownVariable, 'RecipientNmae');

      final eventId = await events.createEvent(
        EventDraft(name: 'E', templateId: t.id),
      );
      expect(
        (await templates.forEvent(await event(eventId))).problem,
        isNotNull,
        reason: 'sending must refuse this template',
      );

      final fixed = await templates.replaceFile(
        t.id,
        't-fixed.html',
        bytes('<p>{{RecipientName}}</p>'),
      );
      expect(fixed.problem, isNull);
      expect(fixed.name, 't', reason: 'the name is kept');
      expect(fixed.fileName, 't-fixed.html');
      final forEvent = await templates.forEvent(await event(eventId));
      expect(forEvent.problem, isNull);
      expect(forEvent.custom!.id, t.id);
    },
  );

  test(
    'deleting a template sends its events back to the built-in one',
    () async {
      final t = await templates.importFile('t.txt', bytes('x'));
      final eventId = await events.createEvent(
        EventDraft(name: 'E', templateId: t.id),
      );

      await templates.delete(t.id);

      final e = await event(eventId);
      expect(e.templateId, isNull);
      expect((await templates.forEvent(e)).custom, isNull);
    },
  );

  test(
    'upgrading a version 1 database keeps events and participants',
    () async {
      final dir = await Directory.systemTemp.createTemp('santaroni_migration');
      addTearDown(() => dir.delete(recursive: true));
      final file = File('${dir.path}/v1.sqlite');

      // The parts of the v1 schema that changed, plus a participant.
      final raw = sqlite3.open(file.path);
      raw.execute('''
      CREATE TABLE settings (key TEXT NOT NULL PRIMARY KEY, value TEXT NOT NULL);
      CREATE TABLE email_templates (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,
        language_code TEXT, subject TEXT NOT NULL, html_body TEXT NOT NULL,
        css TEXT NOT NULL DEFAULT '', text_body TEXT, is_built_in INTEGER NOT NULL DEFAULT 0);
      CREATE TABLE events (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, slug TEXT NOT NULL,
        event_date INTEGER, event_time TEXT, place TEXT, budget_minor INTEGER,
        currency TEXT NOT NULL DEFAULT 'USD', language_code TEXT NOT NULL DEFAULT 'en',
        template_id INTEGER REFERENCES email_templates (id) ON DELETE SET NULL,
        status TEXT NOT NULL DEFAULT 'draft', created_at INTEGER NOT NULL DEFAULT (strftime('%s', CURRENT_TIMESTAMP)));
      CREATE TABLE participants (id INTEGER PRIMARY KEY AUTOINCREMENT,
        event_id INTEGER NOT NULL REFERENCES events (id) ON DELETE CASCADE,
        name TEXT NOT NULL, email TEXT NOT NULL, group_tag TEXT);
      CREATE TABLE wishlist_items (id INTEGER PRIMARY KEY AUTOINCREMENT,
        participant_id INTEGER NOT NULL REFERENCES participants (id) ON DELETE CASCADE,
        position INTEGER NOT NULL, text TEXT NOT NULL, url TEXT);
      CREATE TABLE assignments (event_id INTEGER NOT NULL REFERENCES events (id) ON DELETE CASCADE,
        giver_id INTEGER NOT NULL REFERENCES participants (id) ON DELETE CASCADE,
        recipient_id INTEGER NOT NULL REFERENCES participants (id) ON DELETE RESTRICT,
        send_status TEXT NOT NULL DEFAULT 'pending', sent_at INTEGER, last_error TEXT,
        PRIMARY KEY (event_id, giver_id), UNIQUE (event_id, recipient_id));
      INSERT INTO email_templates (name, subject, html_body) VALUES ('old', 's', 'h');
      INSERT INTO events (name, slug, template_id) VALUES ('Old party', 'old-party', 1);
      INSERT INTO participants (event_id, name, email) VALUES (1, 'Ana', 'ana@example.com');
      PRAGMA user_version = 1;
    ''');
      raw.close();

      final upgraded = AppDatabase(NativeDatabase(file));
      addTearDown(upgraded.close);
      final repo = EventsRepository(upgraded);

      final e = (await repo.watchEvent(1).first)!;
      expect(e.name, 'Old party');
      expect(e.templateId, isNull);
      expect(e.emailSubject, isNull);
      expect(e.archived, isFalse, reason: 'the version 3 column was added');
      expect(
        (await repo.watchParticipants(1).first).single.participant.name,
        'Ana',
      );
      expect(
        await TemplatesRepository(upgraded).watchTemplates().first,
        isEmpty,
      );
      final t = await TemplatesRepository(upgraded)
          .importFile('n.txt', bytes('{{GiverName}}'));
      expect(t.problem, isNull);
    },
  );
}
