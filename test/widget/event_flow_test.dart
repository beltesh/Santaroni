import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:santaroni/app/app.dart';
import 'package:santaroni/app/providers.dart';
import 'package:santaroni/data/database.dart';
import 'package:santaroni/data/events_repository.dart';

AppDatabase _memoryDb() => AppDatabase(DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ));

Widget _app(AppDatabase db) => ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const SantaroniApp(),
    );

/// Drift runs real async work, so let it finish outside the fake clock.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('create an event and add a participant', (tester) async {
    final db = _memoryDb();
    addTearDown(db.close);
    await tester.pumpWidget(_app(db));
    await settle(tester);

    expect(find.text('No events yet'), findsOneWidget);

    await tester.tap(find.text('New Secret Santa'));
    await settle(tester);

    // Saving without a name shows the validation error.
    await tester.tap(find.text('Save'));
    await settle(tester);
    expect(find.text('Please enter a name'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Office Party');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Max budget'), '25');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await settle(tester);

    // Landed on the detail screen.
    expect(find.text('Office Party'), findsOneWidget);
    expect(find.text('Budget: up to \$25'), findsOneWidget);
    expect(find.text('Add people one by one or import a CSV file.'),
        findsOneWidget);

    await tester.tap(find.text('Add participant').first);
    await settle(tester);
    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Ana López');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'not an email');
    await tester.tap(find.text('Save'));
    await settle(tester);
    expect(find.text("That doesn't look like an email address"), findsOneWidget);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'ana@example.com');
    await tester.tap(find.text('Add item'));
    await settle(tester);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Item'), 'Mug');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await settle(tester);

    expect(find.text('Ana López'), findsOneWidget);
    expect(find.text('ana@example.com'), findsOneWidget);
    expect(find.text('Participants (1)'), findsOneWidget);
    expect(find.text('You need at least 3 participants to draw names.'),
        findsOneWidget);

    final stored = await tester.runAsync(() => db.select(db.wishlistItems).get());
    expect(stored!.single.itemText, 'Mug');
  });

  testWidgets('event list renders dates and budgets in Spanish', (tester) async {
    final db = _memoryDb();
    addTearDown(db.close);
    await tester.runAsync(() async {
      await db.setSetting(SettingKeys.languageCode, 'es');
      await EventsRepository(db).createEvent(EventDraft(
        name: 'Intercambio',
        date: DateTime(2026, 12, 20),
        time: '19:30',
        budgetMinor: 50000,
        currency: 'MXN',
        languageCode: 'es',
      ));
    });

    await tester.pumpWidget(_app(db));
    await settle(tester);

    expect(find.text('Intercambio'), findsOneWidget);
    expect(find.textContaining('20 de diciembre de 2026'), findsOneWidget);
    expect(find.text('Sin participantes'), findsOneWidget);

    await tester.tap(find.text('Intercambio'));
    await settle(tester);
    expect(find.textContaining('Presupuesto: hasta'), findsOneWidget);
    expect(find.textContaining('500'), findsOneWidget);
  });
}
