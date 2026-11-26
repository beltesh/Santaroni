import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santaroni/data/database.dart';
import 'package:santaroni/data/events_repository.dart';
import 'package:santaroni/features/home/event_grouping.dart';

void main() {
  late AppDatabase db;
  late EventsRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = EventsRepository(db);
  });
  tearDown(() => db.close());

  test('splits by whether the date has passed, sorted by date', () async {
    final now = DateTime(2026, 11, 25, 15, 30);
    Future<void> add(String name, DateTime? date, [String? time]) =>
        repo.createEvent(EventDraft(name: name, date: date, time: time));

    await add('No date', null);
    await add('Christmas', DateTime(2026, 12, 24));
    await add('Today', DateTime(2026, 11, 25));
    await add('Office, evening', DateTime(2026, 12, 18), '19:00');
    await add('Office, lunch', DateTime(2026, 12, 18), '13:00');
    await add('Last year', DateTime(2025, 12, 20));
    await add('Yesterday', DateTime(2026, 11, 24));

    final groups = groupEvents(await repo.watchEventSummaries().first, now);

    expect(groups.ongoing.map((e) => e.event.name), [
      'Today', // still today: not completed yet
      'Office, lunch',
      'Office, evening',
      'Christmas',
      'No date', // undated last
    ]);
    expect(groups.completed.map((e) => e.event.name), ['Last year', 'Yesterday']);
  });

  test('undated events marked completed go to Completed', () async {
    final now = DateTime(2026, 11, 25);
    await repo.createEvent(const EventDraft(name: 'Undated, ongoing'));
    final done = await repo.createEvent(const EventDraft(name: 'Undated, done'));
    await repo.setArchived(done, archived: true);
    // A future date wins over a stale manual flag.
    final dated = await repo.createEvent(
      EventDraft(name: 'Dated', date: DateTime(2099, 1, 1)),
    );
    await (db.update(db.events)..where((e) => e.id.equals(dated))).write(
      const EventsCompanion(archived: Value(true)),
    );

    final groups = groupEvents(await repo.watchEventSummaries().first, now);
    expect(groups.ongoing.map((e) => e.event.name), ['Dated', 'Undated, ongoing']);
    expect(groups.completed.map((e) => e.event.name), ['Undated, done']);
  });

  test('an archived event must be moved back to ongoing before editing', () async {
    final id = await repo.createEvent(const EventDraft(name: 'E'));
    await repo.setArchived(id, archived: true);
    await expectLater(
      repo.updateEvent(id, EventDraft(name: 'E', date: DateTime(2099, 1, 1))),
      throwsA(isA<EventCompletedException>()),
    );

    await repo.setArchived(id, archived: false);
    await repo.updateEvent(id, EventDraft(name: 'E', date: DateTime(2099, 1, 1)));
    final e = (await repo.watchEvent(id).first)!;
    expect((e.archived, e.eventDate), (false, DateTime(2099, 1, 1)));
  });

  test('handles an empty list', () {
    final groups = groupEvents(const [], DateTime(2026));
    expect(groups.ongoing, isEmpty);
    expect(groups.completed, isEmpty);
  });
}