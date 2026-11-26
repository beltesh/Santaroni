import 'dart:convert';
import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santaroni/core/model/wishlist_entry.dart';
import 'package:santaroni/data/database.dart';
import 'package:santaroni/data/event_export.dart';
import 'package:santaroni/data/events_repository.dart';

void main() {
  late AppDatabase db;
  late EventsRepository repo;
  late int eventId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = EventsRepository(db);
    eventId = await repo.createEvent(
      EventDraft(
        name: 'Comic Book Group Secret Santa 2026',
        date: DateTime(2099, 12, 20),
        time: '19:30',
        place: 'The shop',
        budgetMinor: 2550,
        languageCode: 'en',
      ),
    );
    for (final (name, wishes) in [
      ('Ana', const [WishlistEntry('Saga Vol. 1', 'https://example.com/saga')]),
      ('Beto', const <WishlistEntry>[]),
      ('Carla', const [WishlistEntry('Socks')]),
    ]) {
      await repo.addParticipant(
        eventId,
        ParticipantDraft(
          name: name,
          email: '${name.toLowerCase()}@example.com',
          wishlist: wishes,
        ),
      );
    }
    await repo.drawNames(eventId, random: Random(1));
  });
  tearDown(() => db.close());

  Future<Map<String, dynamic>> export({required bool withAssignments}) async {
    final event = (await repo.watchEvent(eventId).first)!;
    final json = buildEventJson(
      event: event,
      participants: await repo.watchParticipants(eventId).first,
      assignments: withAssignments ? await repo.assignments(eventId) : null,
      exportedAt: DateTime.utc(2026, 11, 25, 12),
    );
    return jsonDecode(json) as Map<String, dynamic>;
  }

  test('file name is the kebab-case event name', () async {
    final event = (await repo.watchEvent(eventId).first)!;
    expect(exportFileName(event), 'comic-book-group-secret-santa-2026.json');
  });

  test('full backup contains event, participants and assignments', () async {
    final data = await export(withAssignments: true);

    expect(data['format'], 'santaroni-event');
    expect(data['version'], 1);
    expect(data['exportedAt'], '2026-11-25T12:00:00.000Z');
    expect(data['event'], {
      'name': 'Comic Book Group Secret Santa 2026',
      'date': '2099-12-20',
      'time': '19:30',
      'place': 'The shop',
      'budget': 25.5,
      'currency': 'USD',
      'emailLanguage': 'en',
      'status': 'generated',
    });
    expect(data['participants'][0], {
      'name': 'Ana',
      'email': 'ana@example.com',
      'group': null,
      'wishlist': [
        {'text': 'Saga Vol. 1', 'url': 'https://example.com/saga'},
      ],
    });
    expect(data['participants'][2]['wishlist'], [
      {'text': 'Socks'},
    ]);
    expect(data['includesAssignments'], isTrue);

    final assignments = (data['assignments'] as List)
        .cast<Map<String, dynamic>>();
    expect(assignments, hasLength(3));
    expect(assignments.map((a) => a['giver']).toSet(), {
      'Ana',
      'Beto',
      'Carla',
    });
    expect(assignments.map((a) => a['recipient']).toSet(), {
      'Ana',
      'Beto',
      'Carla',
    });
    expect(assignments.every((a) => a['giver'] != a['recipient']), isTrue);
    expect(assignments.first['emailStatus'], 'pending');
  });

  test('backup without assignments leaves them out entirely', () async {
    final data = await export(withAssignments: false);
    expect(data['includesAssignments'], isFalse);
    expect(data.containsKey('assignments'), isFalse);
    expect(data['participants'], hasLength(3));
  });

  test('whole budgets are written as integers', () async {
    await repo.updateEvent(
      eventId,
      const EventDraft(name: 'X', budgetMinor: 2500),
    );
    final data = await export(withAssignments: false);
    expect(data['event']['budget'], 25);
    expect(data['event']['date'], isNull);
  });
}
