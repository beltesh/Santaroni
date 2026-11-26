import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:santaroni/app/app.dart';
import 'package:santaroni/app/providers.dart';
import 'package:santaroni/core/email/mail_transport.dart';
import 'package:santaroni/data/database.dart';

import '../fakes.dart';

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => initializeDateFormatting());

  testWidgets('set up Gmail, then send a test email', (tester) async {
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

    await tester.tap(find.byTooltip('Settings'));
    await settle(tester);
    expect(find.text('Not set up yet'), findsOneWidget);
    await tester.tap(find.text('Email account'));
    await settle(tester);

    expect(find.text('Gmail needs an app password'), findsOneWidget);
    expect(find.text('Taking part yourself?'), findsOneWidget);

    // A wrong (normal) password: Gmail refuses, and the app explains why.
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Your name'),
      'Sam',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email address'),
      'sam.santa@gmail.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'App password'),
      'my normal password',
    );
    transport.failWith = const SendException(
      SendFailure.authentication,
      '535 5.7.8 Username and Password not accepted',
    );
    await tester.scrollUntilVisible(
      find.text('Send me a test email'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Send me a test email'));
    await settle(tester);
    expect(find.text("Couldn't send the email"), findsOneWidget);
    expect(
      find.textContaining('app password (not your normal Gmail password)'),
      findsOneWidget,
    );
    await tester.tap(find.text('OK'));
    await settle(tester);

    // The right app password works; the password field now says it's saved.
    expect(find.text('Saved. Leave empty to keep it.'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'App password'),
      'abcd efgh ijkl mnop',
    );
    transport.failWith = null;
    await tester.scrollUntilVisible(
      find.text('Send me a test email'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Send me a test email'));
    await settle(tester);
    expect(find.text('Test email sent'), findsOneWidget);
    expect(
      find.textContaining('Check the inbox of sam.santa@gmail.com'),
      findsOneWidget,
    );
    await tester.tap(find.text('OK'));
    await settle(tester);

    final sent = transport.sent.single;
    expect(sent.password, 'abcdefghijklmnop');
    expect(sent.to, 'sam.santa@gmail.com');
    expect(sent.email.subject, startsWith('[Test] '));
    expect(sent.email.html, isNotNull);
    expect(secrets.values.values.single, 'abcdefghijklmnop');

    // Settings now shows the account.
    await tester.pageBack();
    await settle(tester);
    expect(find.text('sam.santa@gmail.com'), findsOneWidget);
  });
}
