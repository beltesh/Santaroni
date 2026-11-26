import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'data/database.dart';
import 'data/legacy_data_migration.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Emails are formatted in each event's language, which can differ from
  // the app's, so load date formats for every locale up front.
  await initializeDateFormatting();
  // Before the database opens: move data from the pre-rename folder.
  await migrateLegacyDataDirectory();

  // Read the theme and language before drawing anything, so the first
  // frame already looks right.
  final db = AppDatabase.defaults();
  var settings = const <String, String>{};
  try {
    settings = await db.allSettings();
  } catch (_) {
    // Start with the defaults; the app reports database problems itself.
  }

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        initialSettingsProvider.overrideWithValue(settings),
      ],
      child: const SantaroniApp(),
    ),
  );
}
