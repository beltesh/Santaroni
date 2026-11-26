import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:santaroni/core/email/mail_transport.dart';
import 'package:santaroni/core/model/wishlist_entry.dart';
import 'package:santaroni/data/database.dart';
import 'package:santaroni/data/email_account_repository.dart';
import 'package:santaroni/data/events_repository.dart';
import 'package:santaroni/data/send_service.dart';
import 'package:santaroni/data/templates_repository.dart';

import '../fakes.dart';

void main() {
  setUpAll(() => initializeDateFormatting());

  late AppDatabase db;
  late EventsRepository events;
  late TemplatesRepository templates;
  late EmailAccountRepository accounts;
  late FakeMailTransport transport;
  late SendService service;
  late int eventId;

  const names = ['Ana', 'Beto', 'Carla', 'Dani'];
  String email(String name) => '${name.toLowerCase()}@example.com';

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    events = EventsRepository(db);
    templates = TemplatesRepository(db);
    accounts = EmailAccountRepository(db, MemorySecretStore());
    transport = FakeMailTransport();
    service = SendService(
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
        budgetMinor: 2500,
        date: DateTime(2099, 12, 20),
      ),
    );
    for (final n in names) {
      await events.addParticipant(
        eventId,
        ParticipantDraft(
          name: n,
          email: email(n),
          wishlist: [WishlistEntry('$n wants socks')],
        ),
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
    for (final v in await events.assignments(eventId))
      v.giver.name: v.assignment.sendStatus,
  };

  test(
    'refuses to send before names are drawn or without an account',
    () async {
      expect(await service.blockers(eventId), {SendBlocker.notDrawn});
      await accounts.forget();
      expect(await service.blockers(eventId), {
        SendBlocker.notDrawn,
        SendBlocker.accountNotReady,
      });
      expect(
        () => service.sendAll(eventId),
        throwsA(isA<SendBlockedException>()),
      );
    },
  );

  test('refuses a template that needs fixing', () async {
    await events.drawNames(eventId);
    final t = await templates.importFile(
      'bad.txt',
      Uint8List.fromList(utf8.encode('{{Nmae}}')),
    );
    final e = await event();
    await events.updateEvent(
      eventId,
      EventDraft.fromEvent(e).withTemplate(t.id),
    );
    expect(await service.blockers(eventId), {SendBlocker.templateProblem});
  });

  test(
    'sends everyone their own assignment and marks the event sent',
    () async {
      await events.drawNames(eventId);
      final draw = {
        for (final v in await events.assignments(eventId))
          v.giver.name: v.recipient.name,
      };

      final started = <int>[];
      final result = await service.sendAll(eventId, onSending: started.add);

      expect(result.outcome, SendOutcome.finished);
      expect(result.sent, 4);
      expect(started, hasLength(4));
      expect(
        transport.sessionsOpened,
        1,
        reason: 'one connection for the whole run',
      );
      expect(transport.sessionsClosed, 1);
      expect(transport.sent.map((s) => s.to).toSet(), names.map(email).toSet());

      for (final s in transport.sent) {
        final giver = names.firstWhere((n) => email(n) == s.to);
        final recipient = draw[giver]!;
        expect(s.toName, giver);
        expect(
          s.email.text,
          contains("You're the Secret Santa for $recipient"),
        );
        expect(
          s.email.text,
          contains('$recipient wants socks'),
          reason: "the recipient's wishlist",
        );
        expect(s.email.text, contains('Where: The roof'));
        expect(s.email.text, contains('— Sam'));
        expect(
          s.email.subject,
          '🎁 Your Secret Santa assignment for Office Party',
        );
        expect(s.email.html, contains(recipient));
        // Nobody else's assignment leaks into this email.
        for (final other in names.where((n) => n != recipient && n != giver)) {
          expect(s.email.text, isNot(contains('$other wants socks')));
        }
      }

      expect((await statuses()).values.toSet(), {SendStatus.sent});
      expect((await event()).status, EventStatus.sent);
    },
  );

  test('a rejected recipient fails alone; retry sends only that one', () async {
    await events.drawNames(eventId);
    transport.failFor = {
      email('Beto'): const SendException(
        SendFailure.rejected,
        '550 no such user',
      ),
    };

    final first = await service.sendAll(eventId);
    expect(first.outcome, SendOutcome.finished);
    expect((first.sent, first.failed), (3, 1));
    expect((await statuses())['Beto'], SendStatus.failed);
    expect(
      (await event()).status,
      EventStatus.sending,
      reason: 'roster is locked after the first send',
    );
    final beto = (await events.assignments(eventId))
        .firstWhere((v) => v.giver.name == 'Beto');
    expect(beto.assignment.lastError, '550 no such user');

    transport.failFor = {};
    transport.sent.clear();
    final retry = await service.sendAll(eventId);
    expect(retry.sent, 1);
    expect(transport.sent.single.to, email('Beto'));
    expect((await event()).status, EventStatus.sent);
  });

  test('a login problem stops the run at the first email', () async {
    await events.drawNames(eventId);
    transport.failWith = const SendException(
      SendFailure.authentication,
      '535 bad credentials',
    );

    final result = await service.sendAll(eventId);

    expect(result.outcome, SendOutcome.aborted);
    expect(result.error!.failure, SendFailure.authentication);
    final s = await statuses();
    expect(s.values.where((x) => x == SendStatus.failed), hasLength(1));
    expect(s.values.where((x) => x == SendStatus.pending), hasLength(3));
    expect(
      (await event()).status,
      EventStatus.generated,
      reason: 'nothing went out, nothing is locked',
    );
  });

  test(
    'stopping leaves the rest pending, and a later run finishes them',
    () async {
      await events.drawNames(eventId);
      var count = 0;
      final stopped = await service.sendAll(
        eventId,
        onSending: (_) => count++,
        shouldStop: () => count >= 2,
      );
      expect(stopped.outcome, SendOutcome.stopped);
      expect(stopped.sent, 2);

      final rest = await service.sendAll(eventId);
      expect(rest.sent, 2);
      expect(
        transport.sent.map((s) => s.to).toSet(),
        hasLength(4),
        reason: 'no one got two emails',
      );
    },
  );

  test('resend sends one person their email again', () async {
    await events.drawNames(eventId);
    await service.sendAll(eventId);
    transport.sent.clear();

    final carla = (await events.assignments(eventId))
        .firstWhere((v) => v.giver.name == 'Carla');
    final result = await service.resend(eventId, carla.giver.id);

    expect(result.sent, 1);
    expect(transport.sent.single.to, email('Carla'));
    expect(transport.sent.single.email.text, contains(carla.recipient.name));
  });

  test('once sending starts, people can no longer be added', () async {
    await events.drawNames(eventId);
    transport.failFor = {
      email('Ana'): const SendException(SendFailure.rejected, 'x'),
    };
    await service.sendAll(eventId);
    expect(
      () => events.addParticipant(
        eventId,
        const ParticipantDraft(name: 'Eva', email: 'eva@example.com'),
      ),
      throwsA(isA<EventLockedException>()),
    );
  });
}

extension on EventDraft {
  EventDraft withTemplate(int id) => EventDraft(
    name: name,
    date: date,
    time: time,
    place: place,
    budgetMinor: budgetMinor,
    currency: currency,
    languageCode: languageCode,
    templateId: id,
    emailSubject: emailSubject,
  );
}
