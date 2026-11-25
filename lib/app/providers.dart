import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../data/database.dart';
import '../data/events_repository.dart';

/// The single app database. Override it in tests with an in-memory one.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.defaults();
  ref.onDispose(db.close);
  return db;
});

/// The language the user picked, or null to follow the system language.
final localeProvider = StreamProvider<Locale?>((ref) {
  final db = ref.watch(databaseProvider);
  return db
      .watchSetting(SettingKeys.languageCode)
      .map((code) => code == null ? null : Locale(code));
});

final eventsRepositoryProvider = Provider<EventsRepository>(
    (ref) => EventsRepository(ref.watch(databaseProvider)));

final eventSummariesProvider = StreamProvider.autoDispose<List<EventSummary>>(
    (ref) => ref.watch(eventsRepositoryProvider).watchEventSummaries());

final eventProvider = StreamProvider.autoDispose.family<Event?, int>(
    (ref, id) => ref.watch(eventsRepositoryProvider).watchEvent(id));

final participantsProvider =
    StreamProvider.autoDispose.family<List<ParticipantWithWishlist>, int>(
        (ref, eventId) =>
            ref.watch(eventsRepositoryProvider).watchParticipants(eventId));
