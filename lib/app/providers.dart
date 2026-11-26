import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../core/email/mail_transport.dart';
import '../data/cancellation_service.dart';
import '../data/database.dart';
import '../data/email_account_repository.dart';
import '../data/email_service.dart';
import '../data/events_repository.dart';
import '../data/send_service.dart';
import '../data/templates_repository.dart';
import 'themes.dart';

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

/// Appearance: system/dark/light mode plus the chosen dark and light themes.
final themePrefsProvider = StreamProvider<ThemePrefs>((ref) {
  final db = ref.watch(databaseProvider);
  return db
      .select(db.settings)
      .watch()
      .map(
        (rows) =>
            ThemePrefs.fromSettings({for (final r in rows) r.key: r.value}),
      );
});

final eventsRepositoryProvider = Provider<EventsRepository>(
  (ref) => EventsRepository(ref.watch(databaseProvider)),
);

final templatesRepositoryProvider = Provider<TemplatesRepository>(
  (ref) => TemplatesRepository(ref.watch(databaseProvider)),
);

final templatesProvider = StreamProvider.autoDispose<List<EmailTemplate>>(
  (ref) => ref.watch(templatesRepositoryProvider).watchTemplates(),
);

final templateProvider = StreamProvider.autoDispose.family<EmailTemplate?, int>(
  (ref, id) => ref.watch(templatesRepositoryProvider).watchTemplate(id),
);

/// The OS keychain. Override in tests with an in-memory store.
final secretStoreProvider = Provider<SecretStore>(
  (ref) => const KeychainSecretStore(),
);

/// Real SMTP. Override in tests with a fake that records messages.
final mailTransportProvider = Provider<MailTransport>(
  (ref) => const SmtpMailTransport(),
);

final emailAccountRepositoryProvider = Provider<EmailAccountRepository>(
  (ref) => EmailAccountRepository(
    ref.watch(databaseProvider),
    ref.watch(secretStoreProvider),
  ),
);

final emailAccountProvider = StreamProvider.autoDispose<EmailAccount?>(
  (ref) => ref.watch(emailAccountRepositoryProvider).watch(),
);

/// Whether the sending account is ready (address, server and password).
final accountStatusProvider = StreamProvider.autoDispose<AccountStatus>(
  (ref) => ref.watch(emailAccountRepositoryProvider).watchStatus(),
);

final sendServiceProvider = Provider<SendService>(
  (ref) => SendService(
    events: ref.watch(eventsRepositoryProvider),
    templates: ref.watch(templatesRepositoryProvider),
    accounts: ref.watch(emailAccountRepositoryProvider),
    transport: ref.watch(mailTransportProvider),
  ),
);

final cancellationServiceProvider = Provider<CancellationService>(
  (ref) => CancellationService(
    events: ref.watch(eventsRepositoryProvider),
    templates: ref.watch(templatesRepositoryProvider),
    accounts: ref.watch(emailAccountRepositoryProvider),
    transport: ref.watch(mailTransportProvider),
  ),
);

final emailServiceProvider = Provider<EmailService>(
  (ref) => EmailService(
    ref.watch(emailAccountRepositoryProvider),
    ref.watch(mailTransportProvider),
  ),
);

final eventSummariesProvider = StreamProvider.autoDispose<List<EventSummary>>(
  (ref) => ref.watch(eventsRepositoryProvider).watchEventSummaries(),
);

final eventProvider = StreamProvider.autoDispose.family<Event?, int>(
  (ref, id) => ref.watch(eventsRepositoryProvider).watchEvent(id),
);

final assignmentsProvider = StreamProvider.autoDispose
    .family<List<AssignmentView>, int>(
      (ref, eventId) =>
          ref.watch(eventsRepositoryProvider).watchAssignments(eventId),
    );

final participantsProvider = StreamProvider.autoDispose
    .family<List<ParticipantWithWishlist>, int>(
      (ref, eventId) =>
          ref.watch(eventsRepositoryProvider).watchParticipants(eventId),
    );

/// Cancellation emails of a cancelled event, by participant name.
final noticesProvider = StreamProvider.autoDispose
    .family<List<NoticeView>, int>(
      (ref, eventId) =>
          ref.watch(eventsRepositoryProvider).watchNotices(eventId),
    );
