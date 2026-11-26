import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../core/email/template_kind.dart';

export '../core/email/template_kind.dart' show TemplateKind;

part 'database.g.dart';

enum EventStatus {
  /// Participants are still being edited; no assignments yet.
  draft,

  /// Assignments exist but no emails have gone out.
  generated,

  /// At least one email has been sent. Editing now requires splicing.
  sending,

  /// Every participant has received their email.
  sent,
}

enum SendStatus { pending, sent, failed }

/// Key/value app settings (SMTP host, port, username, sender name, language…).
/// The SMTP password is never stored here; it lives in the OS keychain.
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

enum TemplateFormat { text, html }

/// Email body templates imported from files. The built-in ones (per kind
/// and language) live in code and are not stored here.
class EmailTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Display name, from the file name without its extension.
  TextColumn get name => text()();

  /// The imported file's name, shown so the user knows what to update.
  TextColumn get fileName => text()();

  TextColumn get format => textEnum<TemplateFormat>()();

  /// Assignment or cancellation email; each kind has its own variables.
  TextColumn get kind => textEnum<TemplateKind>().withDefault(
    Constant(TemplateKind.assignment.name),
  )();

  /// The file's contents, with `{{Variables}}`. Stored so that moving or
  /// deleting the original file doesn't break anything.
  TextColumn get body => text()();

  DateTimeColumn get importedAt => dateTime().withDefault(currentDateAndTime)();
}

class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();

  /// Kebab-case form of [name], used for the JSON export file name.
  TextColumn get slug => text()();

  /// Date of the gift exchange (date part only).
  DateTimeColumn get eventDate => dateTime().nullable()();

  /// Time of day as "HH:mm", kept separate so a date can have no time.
  TextColumn get eventTime => text().nullable()();
  TextColumn get place => text().nullable()();

  /// Maximum gift budget in minor units (cents), avoiding float rounding.
  IntColumn get budgetMinor => integer().nullable()();

  /// ISO 4217 currency code.
  TextColumn get currency => text().withDefault(const Constant('USD'))();

  /// Language used for this event's emails.
  TextColumn get languageCode => text().withDefault(const Constant('en'))();

  /// Imported template for the email body, or null for the built-in one in
  /// [languageCode].
  @ReferenceName('assignmentTemplateEvents')
  IntColumn get templateId => integer().nullable().references(
    EmailTemplates,
    #id,
    onDelete: KeyAction.setNull,
  )();

  /// Subject line, may contain `{{Variables}}`. Null means the default
  /// subject for [languageCode].
  TextColumn get emailSubject => text().nullable()();

  /// Manually moved to "Completed". Only used for events without a date;
  /// dated events are completed once their date has passed.
  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  /// When the event was cancelled. Cancelling is final: the event is then
  /// completed (read-only), whatever its date.
  DateTimeColumn get cancelledAt => dateTime().nullable()();

  /// The organizer's optional message in the cancellation email.
  TextColumn get cancelNote => text().nullable()();

  /// Imported cancellation template, or null for the built-in one. Kept so
  /// failed cancellation emails can be retried with the same template.
  @ReferenceName('cancellationTemplateEvents')
  IntColumn get cancelTemplateId => integer().nullable().references(
    EmailTemplates,
    #id,
    onDelete: KeyAction.setNull,
  )();

  /// Subject of the cancellation email, or null for the default.
  TextColumn get cancelSubject => text().nullable()();

  TextColumn get status =>
      textEnum<EventStatus>().withDefault(Constant(EventStatus.draft.name))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Participants extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get eventId =>
      integer().references(Events, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get email => text()();

  /// Optional exclusion group: people sharing a tag never draw each other.
  TextColumn get groupTag => text().nullable()();
}

class WishlistItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get participantId =>
      integer().references(Participants, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get itemText => text().named('text')();
  TextColumn get url => text().nullable()();
}

class Assignments extends Table {
  IntColumn get eventId =>
      integer().references(Events, #id, onDelete: KeyAction.cascade)();
  @ReferenceName('givingAssignments')
  IntColumn get giverId =>
      integer().references(Participants, #id, onDelete: KeyAction.cascade)();

  /// Restrict, not cascade: removing someone who is a recipient must go
  /// through a splice first, so their giver is never silently left without
  /// an assignment.
  @ReferenceName('receivingAssignments')
  IntColumn get recipientId =>
      integer().references(Participants, #id, onDelete: KeyAction.restrict)();

  TextColumn get sendStatus =>
      textEnum<SendStatus>().withDefault(Constant(SendStatus.pending.name))();
  DateTimeColumn get sentAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {eventId, giverId};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {eventId, recipientId},
  ];
}

/// One cancellation email per participant, created when an event is
/// cancelled with "notify participants" on.
class CancellationNotices extends Table {
  IntColumn get eventId =>
      integer().references(Events, #id, onDelete: KeyAction.cascade)();
  IntColumn get participantId =>
      integer().references(Participants, #id, onDelete: KeyAction.cascade)();

  TextColumn get sendStatus =>
      textEnum<SendStatus>().withDefault(Constant(SendStatus.pending.name))();
  DateTimeColumn get sentAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {participantId};
}

@DriftDatabase(
  tables: [
    Settings,
    EmailTemplates,
    Events,
    Participants,
    WishlistItems,
    Assignments,
    CancellationNotices,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// For tests, e.g. `AppDatabase(NativeDatabase.memory())`.
  AppDatabase(super.executor);

  /// The app's real database, stored in the per-user application support
  /// folder (%APPDATA% on Windows, app-private storage on Android).
  AppDatabase.defaults()
    : super(
        driftDatabase(
          name: 'santaroni',
          native: DriftNativeOptions(
            databaseDirectory: getApplicationSupportDirectory,
          ),
        ),
      );

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // v1 had an editor-style template table that was never used
        // for sending; replace it with imported-file templates.
        await customStatement('UPDATE events SET template_id = NULL');
        await m.deleteTable('email_templates');
        await m.createTable(emailTemplates);
        await m.addColumn(events, events.emailSubject);
      }
      if (from < 3) {
        await m.addColumn(events, events.archived);
      }
      if (from < 4) {
        // Before v2, the table was just recreated with this column.
        if (from >= 2) {
          await m.addColumn(emailTemplates, emailTemplates.kind);
        }
        await m.addColumn(events, events.cancelledAt);
        await m.addColumn(events, events.cancelNote);
        await m.addColumn(events, events.cancelTemplateId);
        await m.addColumn(events, events.cancelSubject);
        await m.createTable(cancellationNotices);
      }
    },
    beforeOpen: (details) async {
      // SQLite leaves foreign keys off unless asked.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  // --- Settings ------------------------------------------------------------

  Future<String?> getSetting(String key) async {
    final row = await (select(
      settings,
    )..where((s) => s.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Stream<String?> watchSetting(String key) =>
      (select(settings)..where((s) => s.key.equals(key)))
          .watchSingleOrNull()
          .map((row) => row?.value);

  Future<void> setSetting(String key, String? value) async {
    if (value == null) {
      await (delete(settings)..where((s) => s.key.equals(key))).go();
    } else {
      await into(settings).insertOnConflictUpdate(
        SettingsCompanion.insert(key: key, value: value),
      );
    }
  }
}

/// Keys used in the [Settings] table.
abstract final class SettingKeys {
  static const languageCode = 'app.languageCode';
  static const smtpHost = 'smtp.host';
  static const smtpPort = 'smtp.port';
  static const smtpSecurity = 'smtp.security';
  static const smtpUsername = 'smtp.username';
  static const senderName = 'smtp.senderName';
  static const smtpPreset = 'smtp.preset';
}
