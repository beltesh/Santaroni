import 'package:intl/intl.dart';

import '../languages.dart';
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

  /// Formats raw event fields in [languageCode] (see [supportedLanguages]).
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
    final locale = formattingLocale(languageCode);
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
    final s = switch (languageCode) {
      'es' => (
        event: 'Intercambio navideño de la oficina 2026',
        place: 'Casa de Ana, Coyoacán',
        budget: 50000,
        currency: 'MXN',
        giver: 'Alejandro',
        recipient: 'Sofía',
        organizer: 'Paty',
        wishlist: const [
          WishlistEntry(
            'Libro de cocina mexicana',
            'https://example.com/libro',
          ),
          WishlistEntry('Calcetines navideños'),
          WishlistEntry('Una planta suculenta'),
        ],
      ),
      'pt' => (
        event: 'Amigo Secreto da Firma 2026',
        place: 'Casa da Ana, Vila Madalena',
        budget: 10000,
        currency: 'BRL',
        giver: 'João',
        recipient: 'Beatriz',
        organizer: 'Carol',
        wishlist: const [
          WishlistEntry('Livro de receitas', 'https://example.com/livro'),
          WishlistEntry('Meias natalinas'),
          WishlistEntry('Um vasinho de suculenta'),
        ],
      ),
      _ => (
        event: 'Comic Book Group Secret Santa 2026',
        place: "Ana's place",
        budget: 2500,
        currency: 'USD',
        giver: 'Alex',
        recipient: 'Jordan',
        organizer: 'Sam',
        wishlist: const [
          WishlistEntry('Saga Vol. 1', 'https://example.com/saga'),
          WishlistEntry('Any Moebius artbook'),
          WishlistEntry('Good hot sauce'),
        ],
      ),
    };
    return EmailContext.forEvent(
      languageCode: languageCode,
      eventName: s.event,
      date: minimal ? null : DateTime(2026, 12, 20),
      time: minimal ? null : '19:30',
      place: minimal ? null : s.place,
      budgetMinor: minimal ? null : s.budget,
      currency: s.currency,
      giverName: s.giver,
      giverEmail: '${s.giver.toLowerCase().replaceAll('ã', 'a')}@example.com',
      recipientName: s.recipient,
      organizerName: minimal ? null : s.organizer,
      wishlist: minimal ? const [] : s.wishlist,
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
