import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:santaroni/app/app.dart';
import 'package:santaroni/app/providers.dart';
import 'package:santaroni/data/database.dart';
import 'package:santaroni/data/events_repository.dart';

AppDatabase _memoryDb() => AppDatabase(
  DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true),
);

Widget _app(AppDatabase db) => ProviderScope(
  overrides: [databaseProvider.overrideWithValue(db)],
  child: const SantaroniApp(),
);

/// Drift runs real async work, so let it finish outside the fake clock.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

/// A tall phone-shaped window, so long forms fit without scrolling.
void useTallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.5;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('create an event and add a participant', (tester) async {
    useTallScreen(tester);
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
      find.widgetWithText(TextFormField, 'Max budget'),
      '25',
    );
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await settle(tester);

    // Landed on the detail screen.
    expect(find.text('Office Party'), findsOneWidget);
    expect(find.text('Budget: up to \$25'), findsOneWidget);
    // Subject with the event name filled in, and which template is used.
    expect(
      find.text('🎁 Your Secret Santa assignment for Office Party'),
      findsOneWidget,
    );
    expect(find.text('Default (English)'), findsOneWidget);
    expect(
      find.text('Add people one by one or import a CSV file.'),
      findsOneWidget,
    );

    await tester.tap(find.byType(FloatingActionButton));
    await settle(tester);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Name'),
      'Ana López',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'not an email',
    );
    await tester.tap(find.text('Save'));
    await settle(tester);
    expect(
      find.text("That doesn't look like an email address"),
      findsOneWidget,
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'ana@example.com',
    );
    await tester.tap(find.text('Add item'));
    await settle(tester);
    await tester.enterText(find.widgetWithText(TextFormField, 'Item'), 'Mug');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await settle(tester);

    expect(find.text('Ana López'), findsOneWidget);
    expect(find.text('ana@example.com'), findsOneWidget);
    expect(find.text('Participants (1)'), findsOneWidget);
    expect(
      find.text('You need at least 3 participants to draw names.'),
      findsOneWidget,
    );

    final stored = await tester.runAsync(
      () => db.select(db.wishlistItems).get(),
    );
    expect(stored!.single.itemText, 'Mug');
  });

  testWidgets('draw names and review with names hidden until revealed', (
    tester,
  ) async {
    useTallScreen(tester);
    final db = _memoryDb();
    addTearDown(db.close);
    const names = ['Ana', 'Beto', 'Carla', 'Dani'];
    await tester.runAsync(() async {
      final repo = EventsRepository(db);
      final id = await repo.createEvent(const EventDraft(name: 'Party'));
      for (final n in names) {
        await repo.addParticipant(
          id,
          ParticipantDraft(name: n, email: '$n@example.com'),
        );
      }
    });

    await tester.pumpWidget(_app(db));
    await settle(tester);
    await tester.tap(find.text('Party'));
    await settle(tester);

    expect(find.text('Ready to draw names'), findsOneWidget);
    await tester.tap(find.text('Draw names'));
    await settle(tester);
    expect(find.text('Names drawn'), findsWidgets);
    expect(find.textContaining('will cancel the current draw'), findsOneWidget);

    await tester.tap(find.text('Review'));
    await settle(tester);
    expect(find.textContaining('Verified'), findsOneWidget);

    // Hidden: each name appears once (as a giver), never as a recipient.
    for (final n in names) {
      expect(find.text(n), findsOneWidget, reason: '$n should only be a giver');
    }

    // Reveal one row: exactly one recipient name becomes visible.
    await tester.tap(find.byTooltip('Show').first);
    await settle(tester);
    final visibleTwice = names
        .where((n) => find.text(n).evaluate().length == 2)
        .length;
    expect(visibleTwice, 1);

    // Show all: every name appears as giver and as recipient.
    await tester.tap(find.byTooltip('Show all'));
    await settle(tester);
    for (final n in names) {
      expect(find.text(n), findsNWidgets(2));
    }

    // Hide all again.
    await tester.tap(find.byTooltip('Hide all'));
    await settle(tester);
    for (final n in names) {
      expect(find.text(n), findsOneWidget);
    }
  });

  testWidgets('remove all participants after confirming', (tester) async {
    useTallScreen(tester);
    final db = _memoryDb();
    addTearDown(db.close);
    await tester.runAsync(() async {
      final repo = EventsRepository(db);
      final id = await repo.createEvent(const EventDraft(name: 'Party'));
      for (final n in ['Ana', 'Beto']) {
        await repo.addParticipant(
          id,
          ParticipantDraft(name: n, email: '$n@example.com'),
        );
      }
    });

    await tester.pumpWidget(_app(db));
    await settle(tester);
    await tester.tap(find.text('Party'));
    await settle(tester);
    expect(find.text('Participants (2)'), findsOneWidget);

    // Cancelling keeps everyone.
    await tester.tap(find.byTooltip('Remove all'));
    await settle(tester);
    expect(
      find.text('All 2 participants and their wishlists will be removed.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Cancel'));
    await settle(tester);
    expect(find.text('Participants (2)'), findsOneWidget);

    // Confirming removes them, and the button disappears with nobody left.
    await tester.tap(find.byTooltip('Remove all'));
    await settle(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Remove all'));
    await settle(tester);
    expect(find.text('Participants (0)'), findsOneWidget);
    expect(find.byTooltip('Remove all'), findsNothing);
  });

  testWidgets('email subject defaults by language and is validated', (
    tester,
  ) async {
    useTallScreen(tester);
    final db = _memoryDb();
    addTearDown(db.close);
    await tester.pumpWidget(_app(db));
    await settle(tester);
    await tester.tap(find.text('New Secret Santa'));
    await settle(tester);

    final subject = find.widgetWithText(TextFormField, 'Email subject');
    String subjectText() =>
        tester.widget<TextFormField>(subject).controller!.text;
    expect(subjectText(), '🎁 Your Secret Santa assignment for {{EventName}}');

    // Untouched default follows the email language.
    await tester.tap(find.text('Español'));
    await settle(tester);
    expect(subjectText(), '🎁 {{EventName}}: descubre a quién te tocó regalar');
    await tester.tap(find.text('English'));
    await settle(tester);

    // A typo in a variable blocks saving.
    await tester.enterText(find.byType(TextFormField).first, 'Party');
    await tester.enterText(subject, 'Hi {{GiverNmae}}');
    await tester.tap(find.text('Save'));
    await settle(tester);
    expect(
      find.textContaining("isn't a variable Santaroni knows"),
      findsOneWidget,
    );

    await tester.enterText(subject, 'Shh, {{GiverName}}! {{EventName}}');
    await tester.tap(find.text('Save'));
    await settle(tester);

    final events = await tester.runAsync(() => db.select(db.events).get());
    expect(events!.single.emailSubject, 'Shh, {{GiverName}}! {{EventName}}');
  });

  testWidgets('event list renders dates and budgets in Spanish', (
    tester,
  ) async {
    useTallScreen(tester);
    final db = _memoryDb();
    addTearDown(db.close);
    await tester.runAsync(() async {
      await db.setSetting(SettingKeys.languageCode, 'es');
      await EventsRepository(db).createEvent(
        EventDraft(
          name: 'Intercambio',
          date: DateTime(2026, 12, 20),
          time: '19:30',
          budgetMinor: 50000,
          currency: 'MXN',
          languageCode: 'es',
        ),
      );
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
