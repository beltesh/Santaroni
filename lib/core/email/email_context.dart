import 'package:intl/intl.dart';

import '../model/wishlist_entry.dart';
import '../util/currency.dart';

/// The values available to an email template, already formatted for the
/// event's language.
///
/// Optional values are null (never empty strings) when not set: Mustache
/// only skips a `{{#Section}}` for null, so this keeps empty lines out of
/// the email.
class EmailContext {
  EmailContext({
    required this.eventName,
    this.eventDate,
    this.eventTime,
    this.eventPlace,
    this.budget,
    required this.giverName,
    required this.giverEmail,
    required this.recipientName,
    this.organizerName,
    this.wishlist = const [],
  });

  /// Formats raw event fields in [languageCode] ("en" or "es").
  factory EmailContext.forEvent({
    required String languageCode,
    required String eventName,
    DateTime? date,
    String? time,
    String? place,
    int? budgetMinor,
    String currency = defaultCurrency,
    required String giverName,
    required String giverEmail,
    required String recipientName,
    String? organizerName,
    List<WishlistEntry> wishlist = const [],
  }) {
    final locale = languageCode == 'es' ? 'es_MX' : 'en_US';
    return EmailContext(
      eventName: eventName,
      eventDate: date == null
          ? null
          : DateFormat.yMMMMEEEEd(locale).format(date),
      eventTime: _formatTime(time, locale),
      eventPlace: place,
      budget: budgetMinor == null
          ? null
          : formatBudget(budgetMinor, currency, locale: locale),
      giverName: giverName,
      giverEmail: giverEmail,
      recipientName: recipientName,
      organizerName: organizerName,
      wishlist: wishlist,
    );
  }

  final String eventName;
  final String? eventDate;
  final String? eventTime;
  final String? eventPlace;
  final String? budget;
  final String giverName;
  final String giverEmail;
  final String recipientName;
  final String? organizerName;
  final List<WishlistEntry> wishlist;

  /// "Saturday, December 20, 2026 · 7:30 PM", or whichever part is set.
  String? get eventWhen {
    final parts = [?_blank(eventDate), ?_blank(eventTime)];
    return parts.isEmpty ? null : parts.join(' · ');
  }

  Map<String, Object?> toMustache() {
    final place = _blank(eventPlace);
    final budgetText = _blank(budget);
    return {
      'EventName': eventName,
      'EventDate': _blank(eventDate),
      'EventTime': _blank(eventTime),
      'EventWhen': eventWhen,
      'EventPlace': place,
      'Budget': budgetText,
      'HasDetails': eventWhen != null || place != null || budgetText != null,
      'GiverName': giverName,
      'GiverEmail': giverEmail,
      'RecipientName': recipientName,
      'OrganizerName': _blank(organizerName),
      'HasWishlist': wishlist.isNotEmpty,
      'Wishlist': [
        for (final w in wishlist) {'Text': w.text, 'Url': _safeUrl(w.url)},
      ],
    };
  }

  /// Example values for previewing templates. With [minimal], every
  /// optional field is empty, to check that templates handle that well.
  static EmailContext sample(String languageCode, {bool minimal = false}) {
    final es = languageCode == 'es';
    return EmailContext.forEvent(
      languageCode: languageCode,
      eventName: es
          ? 'Intercambio navideño de la oficina 2026'
          : 'Comic Book Group Secret Santa 2026',
      date: minimal ? null : DateTime(2026, 12, 20),
      time: minimal ? null : '19:30',
      place: minimal ? null : (es ? 'Casa de Ana, Coyoacán' : "Ana's place"),
      budgetMinor: minimal ? null : (es ? 50000 : 2500),
      currency: es ? 'MXN' : 'USD',
      giverName: es ? 'Alejandro' : 'Alex',
      giverEmail: es ? 'alejandro@example.com' : 'alex@example.com',
      recipientName: es ? 'Sofía' : 'Jordan',
      organizerName: minimal ? null : (es ? 'Paty' : 'Sam'),
      wishlist: minimal
          ? const []
          : es
          ? const [
              WishlistEntry(
                'Libro de cocina mexicana',
                'https://example.com/libro',
              ),
              WishlistEntry('Calcetines navideños'),
              WishlistEntry('Una planta suculenta'),
            ]
          : const [
              WishlistEntry('Saga Vol. 1', 'https://example.com/saga'),
              WishlistEntry('Any Moebius artbook'),
              WishlistEntry('Good hot sauce'),
            ],
    );
  }

  static String? _blank(String? s) => s == null || s.trim().isEmpty ? null : s;

  /// Only plain web links make it into emails.
  static String? _safeUrl(String? url) {
    final u = url?.trim();
    if (u == null || u.isEmpty) return null;
    final lower = u.toLowerCase();
    return lower.startsWith('https://') || lower.startsWith('http://')
        ? u
        : null;
  }

  static String? _formatTime(String? hhmm, String locale) {
    if (hhmm == null) return null;
    final parts = hhmm.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return DateFormat.jm(locale).format(DateTime(2000, 1, 1, h, m));
  }
}

/// Template variables shown in the editor's "insert variable" list.
enum TemplateVariable {
  eventName('EventName'),
  eventWhen('EventWhen'),
  eventDate('EventDate'),
  eventTime('EventTime'),
  eventPlace('EventPlace'),
  budget('Budget'),
  giverName('GiverName'),
  giverEmail('GiverEmail'),
  recipientName('RecipientName'),
  organizerName('OrganizerName'),
  hasDetails('HasDetails', isSection: true),
  hasWishlist('HasWishlist', isSection: true),
  wishlist('Wishlist', isSection: true);

  const TemplateVariable(this.tag, {this.isSection = false});

  final String tag;

  /// Booleans and lists, inserted as `{{#Tag}}…{{/Tag}}`.
  final bool isSection;

  String get snippet => switch (this) {
    TemplateVariable.wishlist =>
      '{{#Wishlist}}{{Text}}{{#Url}} {{Url}}{{/Url}}{{/Wishlist}}',
    _ when isSection => '{{#$tag}}{{/$tag}}',
    _ => '{{$tag}}',
  };
}
