import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:santaroni/core/email/mail_transport.dart';
import 'package:santaroni/data/cancellation_service.dart';
import 'package:santaroni/data/database.dart';
import 'package:santaroni/data/email_account_repository.dart';
import 'package:santaroni/data/events_repository.dart';
import 'package:santaroni/data/send_service.dart';
import 'package:santaroni/data/templates_repository.dart';
import 'package:sqlite3/sqlite3.dart';

import '../fakes.dart';

void main() {
  setUpAll(() => initializeDateFormatting());

  late AppDatabase db;
  late EventsRepository events;
  late TemplatesRepository templates;
  late EmailAccountRepository accounts;
  late FakeMailTransport transport;
  late CancellationService service;
  late int eventId;

  const names = ['Ana', 'Beto', 'Carla'];
  String email(String name) => '${name.toLowerCase()}@example.com';
  Uint8List bytes(String s) => Uint8List.fromList(utf8.encode(s));

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    events = EventsRepository(db);
    templates = TemplatesRepository(db);
    accounts = EmailAccountRepository(db, MemorySecretStore());
    transport = FakeMailTransport();
    service = CancellationService(
      events: events,
      templates: templates,
      accounts: accounts,
      transport: transport,
      pause: Duration.zero,
    );
    eventId = await events.createEvent(
      EventDraft(
        name: 'Office Party',
        place: 'The roof',
        date: DateTime(2099, 12, 20),
      ),
    );
    for (final n in names) {
      await events.addParticipant(
        eventId,
        ParticipantDraft(name: n, email: email(n)),
      );
    }
    await accounts.save(
      const EmailAccount(senderName: 'Sam', address: 'sam@gmail.com'),
      password: 'secret',
    );
  });
  tearDown(() => db.close());

  Future<Event> event() async => (await events.watchEvent(eventId).first)!;
  Future<Map<String, SendStatus>> statuses() async => {
    for (final n in await events.notices(eventId))
      n.participant.name: n.notice.sendStatus,
  };

  test('cancelling emails everyone, with the note, and is final', () async {
    await events.drawNames(eventId);
    await service.cancel(
      eventId,
      const CancelRequest(note: 'Too many of us\nare traveling.'),
    );

    final e = await event();
    expect(e.isCancelled, isTrue);
    expect(e.isCompletedAt(DateTime.now()), isTrue, reason: 'future date');
    expect(e.cancelNote, 'Too many of us\nare traveling.');
    expect(await statuses(), {for (final n in names) n: SendStatus.pending});

    final result = await service.sendNotices(eventId);
    expect((result.outcome, result.sent), (SendOutcome.finished, 3));
    expect(transport.sent.map((m) => m.to), names.map(email));
    expect(await statuses(), {for (final n in names) n: SendStatus.sent});

    final ana = transport.sent.first.email;
    expect(ana.subject, '❌ Cancelled: Office Party');
    expect(ana.text, contains('Hi Ana,'));
    expect(
      ana.text,
      contains('A note from Sam:\nToo many of us\nare traveling.'),
    );
    expect(ana.html, contains('Cancelled'));
    expect(ana.html, contains('white-space: pre-line'));
    // Nobody's assignment leaks into a cancellation email.
    for (final view in await events.assignments(eventId)) {
      final mail = transport.sent.firstWhere((m) => m.to == view.giver.email);
      expect(mail.email.text, isNot(contains(view.recipient.name)));
    }

    // Read-only from now on.
    await expectLater(
      events.addParticipant(
        eventId,
        const ParticipantDraft(name: 'Dani', email: 'dani@example.com'),
      ),
      throwsA(isA<EventCompletedException>()),
    );
    await expectLater(
      service.cancel(eventId, const CancelRequest()),
      throwsA(isA<SendBlockedException>()),
    );
    // Moving it back to ongoing (undated events' menu) doesn't undo it.
    await events.setArchived(eventId, archived: false);
    expect((await event()).isCompletedAt(DateTime.now()), isTrue);
  });

  test('without a note, the note section is left out', () async {
    await service.cancel(eventId, const CancelRequest(note: '   '));
    await service.sendNotices(eventId);
    final mail = transport.sent.first.email;
    expect((await event()).cancelNote, isNull);
    expect(mail.text, isNot(contains('A note from')));
    expect(mail.html, isNot(contains('class="note"')));
  });

  test('cancelling quietly sends nothing', () async {
    await service.cancel(eventId, const CancelRequest(notify: false));
    expect((await event()).isCancelled, isTrue);
    expect(await events.notices(eventId), isEmpty);
    await service.sendNotices(eventId);
    expect(transport.sent, isEmpty);
  });

  test('emails need a ready account; a quiet cancel does not', () async {
    await accounts.forget();
    expect(await service.cancelBlockers(eventId, const CancelRequest()), {
      SendBlocker.accountNotReady,
    });
    await expectLater(
      service.cancel(eventId, const CancelRequest()),
      throwsA(isA<SendBlockedException>()),
    );
    expect((await event()).isCancelled, isFalse);

    await service.cancel(eventId, const CancelRequest(notify: false));
    expect((await event()).isCancelled, isTrue);
  });

  test(
    'uses an imported template and custom subject in the event language',
    () async {
      await events.updateEvent(
        eventId,
        EventDraft(
          name: 'Intercambio',
          date: DateTime(2099, 12, 20),
          languageCode: 'es',
        ),
      );
      final custom = await templates.importFile(
        'aviso.txt',
        bytes(
          '{{ParticipantName}}: {{EventName}} se canceló.{{#Note}} {{Note}}{{/Note}}',
        ),
        kind: TemplateKind.cancellation,
      );
      await service.cancel(
        eventId,
        CancelRequest(
          note: 'Lo siento',
          templateId: custom.id,
          subject: 'Aviso: {{EventName}}',
        ),
      );
      await service.sendNotices(eventId);
      final mail = transport.sent.first.email;
      expect(mail.subject, 'Aviso: Intercambio');
      expect(mail.text, 'Ana: Intercambio se canceló. Lo siento');

      // The default subject follows the event's language.
      expect(
        (await service.templateFor(
          await event(),
          const CancelRequest(),
        )).subject,
        '❌ Cancelado: {{EventName}}',
      );
    },
  );

  test('a template with assignment variables is refused', () async {
    final wrong = await templates.importFile(
      'oops.txt',
      bytes('You were giving to {{RecipientName}}'),
      kind: TemplateKind.cancellation,
    );
    expect(wrong.problem?.unknownVariable, 'RecipientName');
    expect(
      await service.cancelBlockers(
        eventId,
        CancelRequest(templateId: wrong.id),
      ),
      {SendBlocker.templateProblem},
    );
  });

  test('failures are recorded; retry sends only those', () async {
    await service.cancel(eventId, const CancelRequest());
    transport.failFor = {
      email('Beto'): const SendException(SendFailure.rejected, 'no mailbox'),
    };
    final first = await service.sendNotices(eventId);
    expect((first.sent, first.failed), (2, 1));
    expect((await statuses())['Beto'], SendStatus.failed);

    transport.failFor = {};
    transport.sent.clear();
    final retry = await service.sendNotices(eventId);
    expect(retry.sent, 1);
    expect(transport.sent.single.to, email('Beto'));
    expect(await statuses(), {for (final n in names) n: SendStatus.sent});

    transport.sent.clear();
    final ana = (await events.notices(eventId)).first.participant;
    await service.resendNotice(eventId, ana.id);
    expect(transport.sent.single.to, email('Ana'));
  });

  test('a login problem stops at the first email', () async {
    await service.cancel(eventId, const CancelRequest());
    transport.failWith = const SendException(SendFailure.authentication, 'bad');
    final result = await service.sendNotices(eventId);
    expect((result.outcome, result.failed), (SendOutcome.aborted, 1));
    expect(
      (await statuses()).values.where((s) => s == SendStatus.pending),
      hasLength(2),
    );
  });

  test('upgrading a version 3 database adds cancellation', () async {
    final dir = await Directory.systemTemp.createTemp('santaroni_v3');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/v3.sqlite');

    final raw = sqlite3.open(file.path);
    raw.execute('''
      CREATE TABLE settings (key TEXT NOT NULL PRIMARY KEY, value TEXT NOT NULL);
      CREATE TABLE email_templates (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,
        file_name TEXT NOT NULL, format TEXT NOT NULL, body TEXT NOT NULL,
        imported_at INTEGER NOT NULL DEFAULT (strftime('%s', CURRENT_TIMESTAMP)));
      CREATE TABLE events (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, slug TEXT NOT NULL,
        event_date INTEGER, event_time TEXT, place TEXT, budget_minor INTEGER,
        currency TEXT NOT NULL DEFAULT 'USD', language_code TEXT NOT NULL DEFAULT 'en',
        template_id INTEGER REFERENCES email_templates (id) ON DELETE SET NULL,
        email_subject TEXT, archived INTEGER NOT NULL DEFAULT 0 CHECK (archived IN (0, 1)),
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
      INSERT INTO email_templates (name, file_name, format, body) VALUES ('Mine', 'mine.txt', 'text', '{{GiverName}}');
      INSERT INTO events (name, slug, template_id) VALUES ('Party', 'party', 1);
      INSERT INTO participants (event_id, name, email) VALUES (1, 'Ana', 'ana@example.com');
      PRAGMA user_version = 3;
    ''');
    raw.close();

    final upgraded = AppDatabase(NativeDatabase(file));
    addTearDown(upgraded.close);
    final repo = EventsRepository(upgraded);
    final t = (await TemplatesRepository(
      upgraded,
    ).watchTemplates().first).single;
    expect((t.kind, t.problem), (TemplateKind.assignment, null));
    expect((await repo.watchEvent(1).first)!.cancelledAt, isNull);

    await repo.cancelEvent(1, const CancelRequest(note: 'Sorry'));
    expect((await repo.notices(1)).single.participant.name, 'Ana');
    expect((await repo.watchEvent(1).first)!.cancelNote, 'Sorry');
  });
}
