// Rules for event dates: events can't be scheduled in the past.

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

/// Whether [date] is before today.
bool isPastDate(DateTime date, DateTime now) => _day(date).isBefore(_day(now));

bool isSameDay(DateTime? a, DateTime? b) =>
    a != null && b != null && _day(a) == _day(b);

/// What the date picker allows and where it opens, given the event's
/// current date (if any).
///
/// Only today onwards can be picked. The picker opens on the current date
/// when it's still ahead, otherwise on Christmas Eve this year, or today
/// once Christmas Eve has passed.
({DateTime first, DateTime initial, DateTime last}) eventDatePickerRange(
  DateTime now,
  DateTime? current,
) {
  final today = _day(now);
  final christmasEve = DateTime(now.year, 12, 24);
  final initial = current != null && !isPastDate(current, now)
      ? _day(current)
      : (christmasEve.isBefore(today) ? today : christmasEve);
  var last = DateTime(now.year + 5, 12, 31);
  if (initial.isAfter(last)) last = initial;
  return (first: today, initial: initial, last: last);
}
