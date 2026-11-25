import 'dart:math';

import 'package:drift/drift.dart';

import '../core/assignment/secret_santa_cycle.dart';
import '../core/model/wishlist_entry.dart';
import '../core/util/email.dart';
import '../core/util/slug.dart';
import 'database.dart';

/// Editable fields of an event.
class EventDraft {
  const EventDraft({
    required this.name,
    this.date,
    this.time,
    this.place,
    this.budgetMinor,
    this.currency = 'USD',
    this.languageCode = 'en',
  });

  factory EventDraft.fromEvent(Event e) => EventDraft(
        name: e.name,
        date: e.eventDate,
        time: e.eventTime,
        place: e.place,
        budgetMinor: e.budgetMinor,
        currency: e.currency,
        languageCode: e.languageCode,
      );

  final String name;
  final DateTime? date;

  /// "HH:mm".
  final String? time;
  final String? place;
  final int? budgetMinor;
  final String currency;
  final String languageCode;

  EventsCompanion toCompanion() {
    final trimmedName = name.trim();
    final trimmedPlace = place?.trim();
    return EventsCompanion(
      name: Value(trimmedName),
      slug: Value(slugify(trimmedName)),
      eventDate: Value(date == null
          ? null
          : DateTime(date!.year, date!.month, date!.day)),
      eventTime: Value(time),
      place: Value(
          trimmedPlace == null || trimmedPlace.isEmpty ? null : trimmedPlace),
      budgetMinor: Value(budgetMinor),
      currency: Value(currency),
      languageCode: Value(languageCode),
    );
  }
}

/// Editable fields of a participant.
class ParticipantDraft {
  const ParticipantDraft({
    required this.name,
    required this.email,
    this.groupTag,
    this.wishlist = const [],
  });

  final String name;
  final String email;
  final String? groupTag;
  final List<WishlistEntry> wishlist;

  String? get normalizedGroup {
    final g = groupTag?.trim();
    return g == null || g.isEmpty ? null : g;
  }
}

class ParticipantWithWishlist {
  const ParticipantWithWishlist(this.participant, this.wishlist);

  final Participant participant;
  final List<WishlistItem> wishlist;
}

/// One giver → recipient pair with both people loaded.
class AssignmentView {
  const AssignmentView(this.assignment, this.giver, this.recipient);

  final Assignment assignment;
  final Participant giver;
  final Participant recipient;
}

class EventSummary {
  const EventSummary(this.event, this.participantCount);

  final Event event;
  final int participantCount;
}

/// Thrown when trying to add or remove people after emails went out.
/// Dropouts at that stage must go through the splice flow instead.
class EventLockedException implements Exception {
  const EventLockedException();
}

class DuplicateEmailException implements Exception {
  const DuplicateEmailException(this.email);
  final String email;
}

class EventsRepository {
  EventsRepository(this._db);

  final AppDatabase _db;

  // --- Events --------------------------------------------------------------

  Stream<List<EventSummary>> watchEventSummaries() {
    final count = _db.participants.id.count();
    final query = _db.select(_db.events).join([
      leftOuterJoin(_db.participants,
          _db.participants.eventId.equalsExp(_db.events.id)),
    ])
      ..addColumns([count])
      ..groupBy([_db.events.id])
      ..orderBy([OrderingTerm.desc(_db.events.createdAt)]);
    return query.watch().map((rows) => [
          for (final row in rows)
            EventSummary(row.readTable(_db.events), row.read(count) ?? 0),
        ]);
  }

  Stream<Event?> watchEvent(int id) =>
      (_db.select(_db.events)..where((e) => e.id.equals(id)))
          .watchSingleOrNull();

  Future<int> createEvent(EventDraft draft) =>
      _db.into(_db.events).insert(draft.toCompanion());

  Future<void> updateEvent(int id, EventDraft draft) =>
      (_db.update(_db.events)..where((e) => e.id.equals(id)))
          .write(draft.toCompanion());

  Future<void> deleteEvent(int id) =>
      (_db.delete(_db.events)..where((e) => e.id.equals(id))).go();

  // --- Participants --------------------------------------------------------

  Stream<List<ParticipantWithWishlist>> watchParticipants(int eventId) {
    final p = _db.participants;
    final w = _db.wishlistItems;
    final query = _db.select(p).join([
      leftOuterJoin(w, w.participantId.equalsExp(p.id)),
    ])
      ..where(p.eventId.equals(eventId))
      ..orderBy([
        OrderingTerm.asc(p.name.collate(Collate.noCase)),
        OrderingTerm.asc(p.id),
        OrderingTerm.asc(w.position),
      ]);

    return query.watch().map((rows) {
      final byId = <int, ParticipantWithWishlist>{};
      for (final row in rows) {
        final participant = row.readTable(p);
        final entry = byId.putIfAbsent(
            participant.id, () => ParticipantWithWishlist(participant, []));
        final item = row.readTableOrNull(w);
        if (item != null) entry.wishlist.add(item);
      }
      return byId.values.toList();
    });
  }

  Future<Set<String>> emailsInEvent(int eventId, {int? exceptParticipant}) async {
    final query = _db.select(_db.participants)
      ..where((p) => p.eventId.equals(eventId));
    final rows = await query.get();
    return {
      for (final r in rows)
        if (r.id != exceptParticipant) normalizeEmail(r.email),
    };
  }

  Future<int> addParticipant(int eventId, ParticipantDraft draft) =>
      _db.transaction(() async {
        await _beforeRosterChange(eventId);
        await _ensureUniqueEmail(eventId, draft.email);
        return _insertParticipant(eventId, draft);
      });

  /// Adds many participants at once (CSV import). All or nothing.
  Future<void> importParticipants(
    int eventId,
    List<ParticipantDraft> drafts,
  ) =>
      _db.transaction(() async {
        await _beforeRosterChange(eventId);
        final taken = await emailsInEvent(eventId);
        for (final draft in drafts) {
          if (!taken.add(normalizeEmail(draft.email))) {
            throw DuplicateEmailException(draft.email);
          }
          await _insertParticipant(eventId, draft);
        }
      });

  Future<void> updateParticipant(int id, ParticipantDraft draft) =>
      _db.transaction(() async {
        final existing = await (_db.select(_db.participants)
              ..where((p) => p.id.equals(id)))
            .getSingle();
        await _ensureUniqueEmail(existing.eventId, draft.email,
            exceptParticipant: id);

        // Changing exclusion groups can make current assignments invalid.
        if (existing.groupTag != draft.normalizedGroup) {
          await _beforeRosterChange(existing.eventId);
        }

        await (_db.update(_db.participants)..where((p) => p.id.equals(id)))
            .write(ParticipantsCompanion(
          name: Value(draft.name.trim()),
          email: Value(draft.email.trim()),
          groupTag: Value(draft.normalizedGroup),
        ));
        await (_db.delete(_db.wishlistItems)
              ..where((w) => w.participantId.equals(id)))
            .go();
        await _insertWishlist(id, draft.wishlist);
      });

  Future<void> deleteParticipant(int id) => _db.transaction(() async {
        final existing = await (_db.select(_db.participants)
              ..where((p) => p.id.equals(id)))
            .getSingle();
        await _beforeRosterChange(existing.eventId);
        await (_db.delete(_db.participants)..where((p) => p.id.equals(id)))
            .go();
      });

  /// Removes every participant (and their wishlists) from [eventId].
  Future<void> deleteAllParticipants(int eventId) => _db.transaction(() async {
        await _beforeRosterChange(eventId);
        await (_db.delete(_db.participants)
              ..where((p) => p.eventId.equals(eventId)))
            .go();
      });

  // --- Draw ----------------------------------------------------------------

  /// Draws names for [eventId], replacing any previous (unsent) draw.
  ///
  /// Throws [AssignmentException] when a draw is impossible (too few people,
  /// or exclusion groups that can't be satisfied) and [EventLockedException]
  /// once emails have gone out.
  Future<void> drawNames(int eventId, {Random? random}) =>
      _db.transaction(() async {
        final event = await _event(eventId);
        if (event.status == EventStatus.sending ||
            event.status == EventStatus.sent) {
          throw const EventLockedException();
        }

        final people = await (_db.select(_db.participants)
              ..where((p) => p.eventId.equals(eventId)))
            .get();
        final ids = [for (final p in people) p.id];
        final groups = {for (final p in people) p.id: p.groupTag};

        final draw =
            SecretSantaCycle.generate(ids, groups: groups, random: random);
        // Belt and braces: never store a draw that fails verification.
        final issues = SecretSantaCycle.validate(ids, draw, groups: groups);
        if (issues.isNotEmpty) {
          throw StateError('Generated draw failed verification: $issues');
        }

        await (_db.delete(_db.assignments)
              ..where((a) => a.eventId.equals(eventId)))
            .go();
        await _db.batch((b) {
          for (final MapEntry(key: giver, value: recipient) in draw.entries) {
            b.insert(
              _db.assignments,
              AssignmentsCompanion.insert(
                eventId: eventId,
                giverId: giver,
                recipientId: recipient,
              ),
            );
          }
        });
        await _setStatus(eventId, EventStatus.generated);
      });

  /// All assignments for [eventId], sorted by giver name. Sorting by name
  /// (not by position in the loop) matters: in loop order each row's
  /// recipient would be the next row's giver, revealing the draw.
  Stream<List<AssignmentView>> watchAssignments(int eventId) {
    final a = _db.assignments;
    final giver = _db.alias(_db.participants, 'giver');
    final recipient = _db.alias(_db.participants, 'recipient');
    final query = _db.select(a).join([
      innerJoin(giver, giver.id.equalsExp(a.giverId)),
      innerJoin(recipient, recipient.id.equalsExp(a.recipientId)),
    ])
      ..where(a.eventId.equals(eventId))
      ..orderBy([
        OrderingTerm.asc(giver.name.collate(Collate.noCase)),
        OrderingTerm.asc(giver.id),
      ]);
    return query.watch().map((rows) => [
          for (final row in rows)
            AssignmentView(
              row.readTable(a),
              row.readTable(giver),
              row.readTable(recipient),
            ),
        ]);
  }

  Future<List<AssignmentView>> assignments(int eventId) =>
      watchAssignments(eventId).first;

  // ---------------------------------------------------------------------------

  Future<Event> _event(int eventId) =>
      (_db.select(_db.events)..where((e) => e.id.equals(eventId))).getSingle();

  Future<void> _setStatus(int eventId, EventStatus status) =>
      (_db.update(_db.events)..where((e) => e.id.equals(eventId)))
          .write(EventsCompanion(status: Value(status)));

  /// Before adding/removing people: drafts are free to change; generated
  /// (but unsent) assignments are discarded; once sending has started the
  /// roster is locked.
  Future<void> _beforeRosterChange(int eventId) async {
    final event = await _event(eventId);
    switch (event.status) {
      case EventStatus.draft:
        return;
      case EventStatus.generated:
        await (_db.delete(_db.assignments)
              ..where((a) => a.eventId.equals(eventId)))
            .go();
        await _setStatus(eventId, EventStatus.draft);
      case EventStatus.sending:
      case EventStatus.sent:
        throw const EventLockedException();
    }
  }

  Future<void> _ensureUniqueEmail(
    int eventId,
    String email, {
    int? exceptParticipant,
  }) async {
    final taken =
        await emailsInEvent(eventId, exceptParticipant: exceptParticipant);
    if (taken.contains(normalizeEmail(email))) {
      throw DuplicateEmailException(email);
    }
  }

  Future<int> _insertParticipant(int eventId, ParticipantDraft draft) async {
    final id = await _db.into(_db.participants).insert(
          ParticipantsCompanion.insert(
            eventId: eventId,
            name: draft.name.trim(),
            email: draft.email.trim(),
            groupTag: Value(draft.normalizedGroup),
          ),
        );
    await _insertWishlist(id, draft.wishlist);
    return id;
  }

  Future<void> _insertWishlist(int participantId, List<WishlistEntry> items) =>
      _db.batch((b) {
        var position = 0;
        for (final item in items) {
          final text = item.text.trim();
          final url = item.url?.trim();
          if (text.isEmpty && (url == null || url.isEmpty)) continue;
          b.insert(
            _db.wishlistItems,
            WishlistItemsCompanion.insert(
              participantId: participantId,
              position: position++,
              itemText: text.isEmpty ? url! : text,
              url: Value(url == null || url.isEmpty ? null : url),
            ),
          );
        }
      });
}
