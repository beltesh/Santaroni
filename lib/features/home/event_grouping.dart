import '../../data/events_repository.dart';

/// Events split for the home screen.
typedef GroupedEvents = ({
  List<EventSummary> ongoing,
  List<EventSummary> completed,
});

/// Splits events into ongoing and completed, each sorted by date
/// (earliest first).
///
/// An event is completed once its date has passed; until then it's
/// ongoing, even if all emails went out, since the gift exchange itself
/// hasn't happened yet. Events without a date are ongoing unless the
/// organizer marked them completed. Events without a date sort after
/// dated ones.
GroupedEvents groupEvents(List<EventSummary> events, DateTime now) {
  final ongoing = <EventSummary>[];
  final completed = <EventSummary>[];
  for (final e in events) {
    (e.event.isCompletedAt(now) ? completed : ongoing).add(e);
  }

  int byDate(EventSummary a, EventSummary b) {
    final da = a.event.eventDate, db = b.event.eventDate;
    if (da == null && db == null) {
      return a.event.createdAt.compareTo(b.event.createdAt);
    }
    if (da == null) return 1;
    if (db == null) return -1;
    final byDay = da.compareTo(db);
    if (byDay != 0) return byDay;
    // Same day: earlier time first (events without a time go first).
    return (a.event.eventTime ?? '').compareTo(b.event.eventTime ?? '');
  }

  ongoing.sort(byDate);
  completed.sort(byDate);
  return (ongoing: ongoing, completed: completed);
}
