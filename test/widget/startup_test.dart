import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:santaroni/app/app.dart';
import 'package:santaroni/app/providers.dart';
import 'package:santaroni/app/themes.dart';
import 'package:santaroni/data/database.dart';

void main() {
  setUpAll(() => initializeDateFormatting());

  testWidgets('the first frame already uses the saved theme and language', (
    tester,
  ) async {
    final db = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    addTearDown(db.close);
    const saved = {
      ThemePrefs.keyMode: 'dark',
      ThemePrefs.keyDark: 'dracula',
      SettingKeys.languageCode: 'pt',
    };
    await tester.runAsync(() async {
      for (final e in saved.entries) {
        await db.setSetting(e.key, e.value);
      }
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          initialSettingsProvider.overrideWithValue(saved),
        ],
        child: const SantaroniApp(),
      ),
    );

    // One frame, before the database has answered.
    final context = tester.element(find.byType(Scaffold).first);
    expect(
      Theme.of(context).colorScheme.surface,
      AppTheme.dracula.data.colorScheme.surface,
    );
    expect(Localizations.localeOf(context).languageCode, 'pt');

    // Let the database load and the app finish, so no timers are left.
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump();
    }
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(Scaffold).first)).colorScheme.surface,
      AppTheme.dracula.data.colorScheme.surface,
    );
  });
}
