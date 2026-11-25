import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santaroni/data/database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('settings round-trip and delete', () async {
    expect(await db.getSetting(SettingKeys.languageCode), isNull);
    await db.setSetting(SettingKeys.languageCode, 'es');
    expect(await db.getSetting(SettingKeys.languageCode), 'es');
    await db.setSetting(SettingKeys.languageCode, null);
    expect(await db.getSetting(SettingKeys.languageCode), isNull);
  });

  test('event defaults and cascade delete', () async {
    final eventId = await db.into(db.events).insert(
          EventsCompanion.insert(name: 'Test', slug: 'test'),
        );
    final event = await (db.select(db.events)
          ..where((e) => e.id.equals(eventId)))
        .getSingle();
    expect(event.currency, 'USD');
    expect(event.status, EventStatus.draft);

    final pid = await db.into(db.participants).insert(
          ParticipantsCompanion.insert(
              eventId: eventId, name: 'Ana', email: 'ana@example.com'),
        );
    await db.into(db.wishlistItems).insert(
          WishlistItemsCompanion.insert(
              participantId: pid, position: 0, itemText: 'Book'),
        );

    await (db.delete(db.events)..where((e) => e.id.equals(eventId))).go();
    expect(await db.select(db.participants).get(), isEmpty);
    expect(await db.select(db.wishlistItems).get(), isEmpty);
  });

  test('a recipient cannot be deleted before being spliced out', () async {
    final eventId = await db.into(db.events).insert(
          EventsCompanion.insert(name: 'Test', slug: 'test'),
        );
    final ids = <int>[];
    for (final name in ['A', 'B', 'C']) {
      ids.add(await db.into(db.participants).insert(
            ParticipantsCompanion.insert(
                eventId: eventId, name: name, email: '$name@example.com'),
          ));
    }
    for (var i = 0; i < 3; i++) {
      await db.into(db.assignments).insert(AssignmentsCompanion.insert(
            eventId: eventId,
            giverId: ids[i],
            recipientId: ids[(i + 1) % 3],
          ));
    }

    expect(
      () => (db.delete(db.participants)..where((p) => p.id.equals(ids[1])))
          .go(),
      throwsA(isA<SqliteException>()),
    );
  });
}
