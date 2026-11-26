import 'dart:math';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santaroni/core/assignment/secret_santa_cycle.dart';
import 'package:santaroni/core/model/wishlist_entry.dart';
import 'package:santaroni/data/database.dart';
import 'package:santaroni/data/events_repository.dart';

void main() {
  late AppDatabase db;
  late EventsRepository repo;
  late int eventId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = EventsRepository(db);
    eventId = await repo.createEvent(
      const EventDraft(name: '  Navidad Año 2026 '),
    );
  });
  tearDown(() => db.close());

  ParticipantDraft person(
    String name, {
    String? group,
    List<WishlistEntry>? wishes,
  }) => ParticipantDraft(
    name: name,
    email: '${name.toLowerCase()}@example.com',
    groupTag: group,
    wishlist: wishes ?? const [],
  );

  Future<void> setStatus(EventStatus status) =>
      (db.update(db.events)..where((e) => e.id.equals(eventId))).write(
        EventsCompanion(status: Value(status)),
      );

  test('createEvent trims the name and derives the slug', () async {
    final event = await repo.watchEvent(eventId).first;
    expect(event!.name, 'Navidad Año 2026');
    expect(event.slug, 'navidad-ano-2026');
  });

  test('participants come back sorted with ordered wishlists', () async {
    await repo.addParticipant(eventId, person('beto'));
    await repo.addParticipant(
      eventId,
      person(
        'Ana',
        wishes: const [
          WishlistEntry('Book', 'https://example.com/book'),
          WishlistEntry('  '), // Blank items are dropped.
          WishlistEntry('Socks'),
        ],
      ),
    );

    final list = await repo.watchParticipants(eventId).first;
    expect(list.map((p) => p.participant.name), ['Ana', 'beto']);
    expect(list.first.wishlist.map((w) => (w.itemText, w.url, w.position)), [
      ('Book', 'https://example.com/book', 0),
      ('Socks', null, 1),
    ]);
    expect(list.last.wishlist, isEmpty);

    final summaries = await repo.watchEventSummaries().first;
    expect(summaries.single.participantCount, 2);
  });

  test('rejects duplicate emails, ignoring case and spaces', () async {
    await repo.addParticipant(eventId, person('Ana'));
    expect(
      () => repo.addParticipant(
        eventId,
        const ParticipantDraft(name: 'Other', email: ' ANA@example.com '),
      ),
      throwsA(isA<DuplicateEmailException>()),
    );
  });

  test('updating keeps your own email and replaces the wishlist', () async {
    final id = await repo.addParticipant(
      eventId,
      person('Ana', wishes: const [WishlistEntry('Old')]),
    );
    await repo.updateParticipant(
      id,
      person('Ana', wishes: const [WishlistEntry('New')]),
    );
    final list = await repo.watchParticipants(eventId).first;
    expect(list.single.wishlist.single.itemText, 'New');
  });

  test('import is all-or-nothing', () async {
    await repo.addParticipant(eventId, person('Ana'));
    await expectLater(
      repo.importParticipants(eventId, [person('Beto'), person('Ana')]),
      throwsA(isA<DuplicateEmailException>()),
    );
    final list = await repo.watchParticipants(eventId).first;
    expect(list.map((p) => p.participant.name), ['Ana']);
  });

  test('changing the roster after a draw discards the draw', () async {
    final ids = [
      for (final n in ['Ana', 'Beto', 'Carla'])
        await repo.addParticipant(eventId, person(n)),
    ];
    for (var i = 0; i < 3; i++) {
      await db
          .into(db.assignments)
          .insert(
            AssignmentsCompanion.insert(
              eventId: eventId,
              giverId: ids[i],
              recipientId: ids[(i + 1) % 3],
            ),
          );
    }
    await setStatus(EventStatus.generated);

    await repo.addParticipant(eventId, person('Dani'));

    expect(await db.select(db.assignments).get(), isEmpty);
    expect((await repo.watchEvent(eventId).first)!.status, EventStatus.draft);
  });

  test('editing a name after a draw keeps the draw', () async {
    final id = await repo.addParticipant(eventId, person('Ana', group: 'x'));
    await setStatus(EventStatus.generated);
    await repo.updateParticipant(id, person('Ana María', group: 'X'));
    // Group "x" → "X" still differs as text, so it resets; same text would not.
    expect((await repo.watchEvent(eventId).first)!.status, EventStatus.draft);

    await setStatus(EventStatus.generated);
    await repo.updateParticipant(id, person('Ana', group: 'X'));
    expect(
      (await repo.watchEvent(eventId).first)!.status,
      EventStatus.generated,
    );
  });

  test('the roster is locked once sending starts', () async {
    final id = await repo.addParticipant(eventId, person('Ana'));
    await setStatus(EventStatus.sending);

    expect(
      () => repo.addParticipant(eventId, person('Beto')),
      throwsA(isA<EventLockedException>()),
    );
    expect(
      () => repo.deleteParticipant(id),
      throwsA(isA<EventLockedException>()),
    );
    // Fixing a typo in an email is still allowed.
    await repo.updateParticipant(
      id,
      const ParticipantDraft(name: 'Ana', email: 'ana2@example.com'),
    );
  });

  test('deleting an event removes its participants', () async {
    await repo.addParticipant(eventId, person('Ana'));
    await repo.deleteEvent(eventId);
    expect(await db.select(db.participants).get(), isEmpty);
  });

  test('deleteAllParticipants clears the roster and cancels a draw', () async {
    for (final n in ['Ana', 'Beto', 'Carla']) {
      await repo.addParticipant(
        eventId,
        person(n, wishes: const [WishlistEntry('Gift')]),
      );
    }
    await repo.drawNames(eventId);

    await repo.deleteAllParticipants(eventId);

    expect(await repo.watchParticipants(eventId).first, isEmpty);
    expect(await db.select(db.wishlistItems).get(), isEmpty);
    expect(await db.select(db.assignments).get(), isEmpty);
    expect((await repo.watchEvent(eventId).first)!.status, EventStatus.draft);

    await setStatus(EventStatus.sent);
    expect(
      () => repo.deleteAllParticipants(eventId),
      throwsA(isA<EventLockedException>()),
    );
  });

  group('drawNames', () {
    Future<List<int>> addPeople(
      List<String> names, {
      Map<String, String>? groups,
    }) async => [
      for (final n in names)
        await repo.addParticipant(eventId, person(n, group: groups?[n])),
    ];

    test('stores a verified single cycle and marks the event drawn', () async {
      final ids = await addPeople(['Ana', 'Beto', 'Carla', 'Dani', 'Eva']);
      await repo.drawNames(eventId, random: Random(1));

      final views = await repo.assignments(eventId);
      final map = {for (final v in views) v.giver.id: v.recipient.id};
      expect(SecretSantaCycle.isValid(ids, map), isTrue);
      expect(
        (await repo.watchEvent(eventId).first)!.status,
        EventStatus.generated,
      );
      expect(
        views.every((v) => v.assignment.sendStatus == SendStatus.pending),
        isTrue,
      );
    });

    test('lists assignments by giver name, not loop order', () async {
      await addPeople(['Zoe', 'ana', 'Mario', 'beto']);
      await repo.drawNames(eventId, random: Random(3));
      final views = await repo.assignments(eventId);
      expect(views.map((v) => v.giver.name), ['ana', 'beto', 'Mario', 'Zoe']);
    });

    test('redrawing replaces the previous draw', () async {
      await addPeople(['Ana', 'Beto', 'Carla', 'Dani']);
      await repo.drawNames(eventId, random: Random(1));
      await repo.drawNames(eventId, random: Random(2));
      expect(await repo.assignments(eventId), hasLength(4));
    });

    test('respects exclusion groups', () async {
      await addPeople(
        ['Ana', 'Beto', 'Carla', 'Dani'],
        groups: {'Ana': 'couple', 'Beto': 'couple'},
      );
      for (var seed = 0; seed < 20; seed++) {
        await repo.drawNames(eventId, random: Random(seed));
        for (final v in await repo.assignments(eventId)) {
          expect({v.giver.name, v.recipient.name}, isNot({'Ana', 'Beto'}));
        }
      }
    });

    test('fails cleanly when impossible, keeping the event a draft', () async {
      await addPeople(['Ana', 'Beto']);
      await expectLater(
        repo.drawNames(eventId),
        throwsA(isA<AssignmentException>()),
      );

      await addPeople(['Carla'], groups: {'Carla': 'x'});
      await repo.updateParticipant(
        (await repo.watchParticipants(eventId).first).first.participant.id,
        person('Ana', group: 'x'),
      );
      await expectLater(
        repo.drawNames(eventId),
        throwsA(isA<AssignmentException>()),
      );

      expect(await repo.assignments(eventId), isEmpty);
      expect((await repo.watchEvent(eventId).first)!.status, EventStatus.draft);
    });

    test('is refused once sending has started', () async {
      await addPeople(['Ana', 'Beto', 'Carla']);
      await setStatus(EventStatus.sending);
      expect(
        () => repo.drawNames(eventId),
        throwsA(isA<EventLockedException>()),
      );
    });
  });
}
