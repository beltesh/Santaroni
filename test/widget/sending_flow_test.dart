import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:santaroni/app/app.dart';
import 'package:santaroni/app/providers.dart';
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

      expect(sendButtonColor(), isNot(const Color(0xFF2E7D32)));

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
      expect(sendButtonColor(), const Color(0xFF2E7D32));
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
}
