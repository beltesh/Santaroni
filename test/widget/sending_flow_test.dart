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
import 'package:santaroni/data/email_account_repository.dart';
import 'package:santaroni/data/events_repository.dart';

import '../fakes.dart';

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => initializeDateFormatting());

  testWidgets(
    'account shortcut turns green, then emails go out from the event',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 2600);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(tester.view.reset);

      final db = AppDatabase(
        DatabaseConnection(
          NativeDatabase.memory(),
          closeStreamsSynchronously: true,
        ),
      );
      addTearDown(db.close);
      final secrets = MemorySecretStore();
      final transport = FakeMailTransport();

      await tester.runAsync(() async {
        final repo = EventsRepository(db);
        final id = await repo.createEvent(const EventDraft(name: 'Party'));
        for (final n in ['Ana', 'Beto', 'Carla']) {
          await repo.addParticipant(
            id,
            ParticipantDraft(name: n, email: '$n@example.com'),
          );
        }
        await repo.drawNames(id);
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            secretStoreProvider.overrideWithValue(secrets),
            mailTransportProvider.overrideWithValue(transport),
          ],
          child: const SantaroniApp(),
        ),
      );
      await settle(tester);

      // No account yet: amber shortcut on home, banner on the event.
      expect(find.text('Set up email'), findsOneWidget);
      expect(find.text('Email templates'), findsOneWidget);
      await tester.tap(find.text('Party'));
      await settle(tester);
      expect(
        find.text(
          "Set up the email account you'll send these assignments from.",
        ),
        findsOneWidget,
      );
      // Export moved to the top bar.
      expect(find.byTooltip('Export JSON'), findsOneWidget);

      // The "ready to send" green of whichever theme is showing.
      Color goGreen() =>
          StatusColors.go(tester.element(find.byType(Scaffold).last))
              .background;

      // Not ready yet, so the send button is a plain (not green) one.
      Color? sendButtonColor() {
        final button = tester.widget<ButtonStyleButton>(
          find.ancestor(
            of: find.text('Send emails'),
            matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
          ),
        );
        return button.style?.backgroundColor?.resolve({});
      }

      expect(sendButtonColor(), isNot(goGreen()));

      // The send screen blocks sending until the account exists.
      await tester.tap(find.text('Send emails'));
      await settle(tester);
      expect(find.text("Email account isn't set up"), findsOneWidget);
      final sendButton = find.widgetWithText(FilledButton, 'Send 3 emails');
      expect(tester.widget<FilledButton>(sendButton).onPressed, isNull);

      // Set it up (as if through the account screen).
      await tester.runAsync(
        () => EmailAccountRepository(db, secrets).save(
          const EmailAccount(senderName: 'Sam', address: 'sam@gmail.com'),
          password: 'secret',
        ),
      );
      await settle(tester);
      expect(find.text('Email account is ready'), findsOneWidget);
      expect(find.text('Names drawn and verified'), findsOneWidget);

      // Back on the event, everything is ready: the button is solid green.
      await tester.pageBack();
      await settle(tester);
      expect(sendButtonColor(), goGreen());
      await tester.tap(find.text('Send emails'));
      await settle(tester);

      await tester.tap(sendButton);
      await settle(tester);
      expect(find.text('Send 3 emails?'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Send'));
      await settle(tester);

      expect(find.text('All emails sent'), findsOneWidget);
      expect(transport.sent, hasLength(3));
      expect(find.byTooltip('Resend'), findsNWidgets(3));
      // Recipients never appear on this screen: each name shows once (giver).
      for (final n in ['Ana', 'Beto', 'Carla']) {
        expect(find.text(n), findsOneWidget);
      }

      // Resend one.
      transport.sent.clear();
      await tester.tap(find.byTooltip('Resend').first);
      await settle(tester);
      expect(find.text('Resend to Ana?'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Resend'));
      await settle(tester);
      expect(transport.sent.single.to, 'Ana@example.com');

      // Home now shows the account as ready, in green.
      await tester.pageBack();
      await settle(tester);
      await tester.pageBack();
      await settle(tester);
      expect(find.text('Ready to send'), findsOneWidget);
      expect(find.text('sam@gmail.com'), findsOneWidget);
    },
  );

  testWidgets('cancelling an event emails everyone and makes it read-only', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2600);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);

    final db = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    addTearDown(db.close);
    final secrets = MemorySecretStore();
    final transport = FakeMailTransport();

    await tester.runAsync(() async {
      final repo = EventsRepository(db);
      final id = await repo.createEvent(
        EventDraft(name: 'Party', date: DateTime(2099, 12, 20)),
      );
      for (final n in ['Ana', 'Beto', 'Carla']) {
        await repo.addParticipant(
          id,
          ParticipantDraft(name: n, email: '$n@example.com'),
        );
      }
      await EmailAccountRepository(db, secrets).save(
        const EmailAccount(senderName: 'Sam', address: 'sam@gmail.com'),
        password: 'secret',
      );
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          secretStoreProvider.overrideWithValue(secrets),
          mailTransportProvider.overrideWithValue(transport),
        ],
        child: const SantaroniApp(),
      ),
    );
    await settle(tester);

    await tester.tap(find.text('Party'));
    await settle(tester);
    await tester.tap(find.byType(PopupMenuButton<void>));
    await settle(tester);
    await tester.tap(find.text('Cancel event…'));
    await settle(tester);

    expect(find.text('Cancel “Party”?'), findsOneWidget);
    expect(find.text('Email all 3 participants'), findsOneWidget);
    // Keeping the event changes nothing.
    await tester.tap(find.text('Keep event'));
    await settle(tester);
    expect(find.byTooltip('Edit'), findsOneWidget);

    await tester.tap(find.byType(PopupMenuButton<void>));
    await settle(tester);
    await tester.tap(find.text('Cancel event…'));
    await settle(tester);
    await tester.enterText(
      find.widgetWithText(TextField, 'Note (optional)'),
      'See you in January!',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Cancel event'));
    await settle(tester);

    // Straight to the emails, which go out right away.
    expect(find.text('Cancellation emails'), findsOneWidget);
    expect(find.text('All emails sent'), findsOneWidget);
    expect(transport.sent.map((m) => m.to), [
      'Ana@example.com',
      'Beto@example.com',
      'Carla@example.com',
    ]);
    expect(transport.sent.first.email.text, contains('See you in January!'));

    // The event is now cancelled and read-only.
    await tester.pageBack();
    await settle(tester);
    expect(find.textContaining('This event was cancelled on'), findsOneWidget);
    expect(find.text('Cancelled'), findsOneWidget);
    expect(find.text('See you in January!'), findsOneWidget);
    expect(find.byTooltip('Edit'), findsNothing);
    expect(find.text('Add participant'), findsNothing);
    await tester.tap(find.byType(PopupMenuButton<void>));
    await settle(tester);
    expect(find.text('Cancel event…'), findsNothing);
    await tester.tapAt(Offset.zero);
    await settle(tester);

    // Home lists it under Completed.
    await tester.pageBack();
    await settle(tester);
    expect(find.text('Completed (1)'), findsOneWidget);
    expect(find.text('Party'), findsNothing, reason: 'Completed is closed');
  });
}
