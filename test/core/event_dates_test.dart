import 'package:flutter_test/flutter_test.dart';
import 'package:santaroni/features/events/event_dates.dart';

void main() {
  final now = DateTime(2026, 11, 25, 18, 45);

  test('only today and later can be picked', () {
    final r = eventDatePickerRange(now, null);
    expect(r.first, DateTime(2026, 11, 25));
    expect(r.last.isAfter(DateTime(2031)), isTrue);
  });

  test('opens on Christmas Eve, or the current date if still ahead', () {
    expect(eventDatePickerRange(now, null).initial, DateTime(2026, 12, 24));
    expect(eventDatePickerRange(now, DateTime(2027, 1, 10)).initial, DateTime(2027, 1, 10));
    expect(eventDatePickerRange(now, DateTime(2026, 11, 25)).initial, DateTime(2026, 11, 25));
  });

  test('an event already in the past opens the picker on a valid day', () {
    expect(eventDatePickerRange(now, DateTime(2020, 12, 20)).initial, DateTime(2026, 12, 24));
    // After Christmas Eve, it opens on today.
    final late = DateTime(2026, 12, 28);
    expect(eventDatePickerRange(late, DateTime(2026, 12, 1)).initial, DateTime(2026, 12, 28));
  });

  test('isPastDate compares whole days', () {
    expect(isPastDate(DateTime(2026, 11, 24, 23, 59), now), isTrue);
    expect(isPastDate(DateTime(2026, 11, 25), now), isFalse, reason: 'today is fine');
    expect(isPastDate(DateTime(2026, 11, 26), now), isFalse);
  });
}
