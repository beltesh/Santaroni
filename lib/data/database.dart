import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

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

class EmailTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();

  /// Language of the built-in template ("en", "es"); null for custom ones.
  TextColumn get languageCode => text().nullable()();

  /// Mustache template for the subject line.
  TextColumn get subject => text()();

  /// Mustache template for the HTML body.
  TextColumn get htmlBody => text()();

  /// CSS applied to the HTML body. Inlined into elements at send time,
  /// because many email clients ignore `<style>` blocks.
  TextColumn get css => text().withDefault(const Constant(''))();

  /// Mustache template for the plain-text alternative. When null, a plain
  /// version is derived from the HTML.
  TextColumn get textBody => text().nullable()();

  BoolColumn get isBuiltIn => boolean().withDefault(const Constant(false))();
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

  IntColumn get templateId => integer()
      .nullable()
      .references(EmailTemplates, #id, onDelete: KeyAction.setNull)();

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

@DriftDatabase(
  tables: [
    Settings,
    EmailTemplates,
    Events,
    Participants,
    WishlistItems,
    Assignments,
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
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          // SQLite leaves foreign keys off unless asked.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // --- Settings ------------------------------------------------------------

  Future<String?> getSetting(String key) async {
    final row = await (select(settings)..where((s) => s.key.equals(key)))
        .getSingleOrNull();
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
