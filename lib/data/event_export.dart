import 'dart:convert';

import '../core/util/currency.dart';
import 'database.dart';
import 'events_repository.dart';

/// Identifies Santaroni backups, so a future import can recognize them.
const exportFormat = 'santaroni-event';
const exportVersion = 1;

/// File name for an event backup: "comic-book-group-secret-santa-2026.json".
String exportFileName(Event event) => '${event.slug}.json';

/// Builds a human-readable JSON backup of an event.
///
/// With [assignments] it is a full record of who gives to whom, so anyone
/// opening the file sees the draw. Pass null to leave assignments out.
String buildEventJson({
  required Event event,
  required List<ParticipantWithWishlist> participants,
  List<AssignmentView>? assignments,
  required DateTime exportedAt,
}) {
  String? isoDate(DateTime? d) => d == null
      ? null
      : '${d.year.toString().padLeft(4, '0')}-'
            '${d.month.toString().padLeft(2, '0')}-'
            '${d.day.toString().padLeft(2, '0')}';

  num? budget() {
    final minor = event.budgetMinor;
    if (minor == null) return null;
    var scale = 1;
    for (var i = 0; i < currencyDecimalDigits(event.currency); i++) {
      scale *= 10;
    }
    return minor % scale == 0 ? minor ~/ scale : minor / scale;
  }

  final data = <String, Object?>{
    'format': exportFormat,
    'version': exportVersion,
    'exportedAt': exportedAt.toUtc().toIso8601String(),
    'event': {
      'name': event.name,
      'date': isoDate(event.eventDate),
      'time': event.eventTime,
      'place': event.place,
      'budget': budget(),
      'currency': event.currency,
      'emailLanguage': event.languageCode,
      'status': event.status.name,
      if (event.cancelledAt != null) ...{
        'cancelledAt': event.cancelledAt!.toUtc().toIso8601String(),
        'cancellationNote': event.cancelNote,
      },
    },
    'participants': [
      for (final p in participants)
        {
          'name': p.participant.name,
          'email': p.participant.email,
          'group': p.participant.groupTag,
          'wishlist': [
            for (final w in p.wishlist)
              {'text': w.itemText, if (w.url != null) 'url': w.url},
          ],
        },
    ],
    'includesAssignments': assignments != null,
    if (assignments != null)
      'assignments': [
        for (final a in assignments)
          {
            'giver': a.giver.name,
            'giverEmail': a.giver.email,
            'recipient': a.recipient.name,
            'recipientEmail': a.recipient.email,
            'emailStatus': a.assignment.sendStatus.name,
          },
      ],
  };

  return '${const JsonEncoder.withIndent('  ').convert(data)}\n';
}
