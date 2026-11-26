import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/languages.dart';
import '../../core/util/currency.dart';
import '../../data/database.dart';
import '../../data/events_repository.dart';
import '../../l10n/app_localizations.dart';

String _localeName(BuildContext context) =>
    Localizations.localeOf(context).toLanguageTag();

TimeOfDay? parseTime(String? hhmm) {
  if (hhmm == null) return null;
  final parts = hhmm.split(':');
  if (parts.length != 2) return null;
  final h = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  if (h == null || m == null) return null;
  return TimeOfDay(hour: h, minute: m);
}

String timeToString(TimeOfDay t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

String formatDate(BuildContext context, DateTime date) =>
    DateFormat.yMMMMEEEEd(_localeName(context)).format(date);

String formatTime(BuildContext context, TimeOfDay time) =>
    MaterialLocalizations.of(context).formatTimeOfDay(time);

/// "Saturday, December 20, 2026 · 7:00 PM", or null when no date is set.
String? formatEventWhen(BuildContext context, Event event) {
  final date = event.eventDate;
  final time = parseTime(event.eventTime);
  if (date == null && time == null) return null;
  return [
    if (date != null) formatDate(context, date),
    if (time != null) formatTime(context, time),
  ].join(' · ');
}

String? formatEventBudget(BuildContext context, Event event) {
  final budget = event.budgetMinor;
  if (budget == null) return null;
  return formatBudget(budget, event.currency, locale: _localeName(context));
}

String currencySymbol(String code) =>
    NumberFormat.simpleCurrency(name: code).currencySymbol;

String statusLabel(AppLocalizations l10n, EventStatus status) =>
    switch (status) {
      EventStatus.draft => l10n.statusDraft,
      EventStatus.generated => l10n.statusGenerated,
      EventStatus.sending => l10n.statusSending,
      EventStatus.sent => l10n.statusSent,
    };

/// The status chip text: "Cancelled" for cancelled events, otherwise the
/// sending stage.
String eventStatusLabel(AppLocalizations l10n, Event event) =>
    event.isCancelled ? l10n.statusCancelled : statusLabel(l10n, event.status);

String initials(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((p) => p.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '?';
  final first = parts.first.characters.first;
  final last = parts.length > 1 ? parts.last.characters.first : '';
  return (first + last).toUpperCase();
}

/// "Santaroni", or "Santaroni Dev" in debug and profile builds, matching
/// the separate dev app on Android so the two are easy to tell apart.
String appDisplayName(AppLocalizations l10n) =>
    kReleaseMode ? l10n.appTitle : '${l10n.appTitle} Dev';

/// The app's current language, as one of [supportedLanguages].
String appLanguage(BuildContext context) =>
    supportedLanguage(Localizations.localeOf(context).languageCode);
