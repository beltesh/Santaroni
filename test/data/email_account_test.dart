import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:santaroni/core/email/builtin_templates.dart';
import 'package:santaroni/core/email/email_providers.dart';
import 'package:santaroni/core/email/email_renderer.dart';
import 'package:santaroni/core/email/mail_transport.dart';
import 'package:santaroni/data/database.dart';
import 'package:santaroni/data/email_account_repository.dart';
import 'package:santaroni/data/email_service.dart';

import '../fakes.dart';

void main() {
  setUpAll(() => initializeDateFormatting());

  late AppDatabase db;
  late MemorySecretStore secrets;
  late EmailAccountRepository accounts;
  late FakeMailTransport transport;
  late EmailService service;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    secrets = MemorySecretStore();
    accounts = EmailAccountRepository(db, secrets);
    transport = FakeMailTransport();
    service = EmailService(accounts, transport);
  });
  tearDown(() => db.close());

  const gmail = EmailAccount(senderName: 'Sam', address: 'sam.santa@gmail.com');

  group('EmailAccountRepository', () {
    test(
      'saves settings to the database and the password to the keychain only',
      () async {
        await accounts.save(gmail, password: 'abcd efgh ijkl mnop');

        final loaded = (await accounts.load())!;
        expect(loaded.address, 'sam.santa@gmail.com');
        expect(loaded.senderName, 'Sam');
        expect(loaded.provider, EmailProvider.gmail);
        // Gmail shows app passwords with spaces; they aren't part of it.
        expect(await accounts.password(), 'abcdefghijklmnop');

        final dbValues = (await db.select(db.settings).get())
            .map((r) => r.value)
            .join(' ');
        expect(
          dbValues,
          isNot(contains('abcd')),
          reason: 'password must not reach the database',
        );
      },
    );

    test('an empty password keeps the saved one', () async {
      await accounts.save(gmail, password: 'secret');
      await accounts.save(gmail, password: '');
      expect(await accounts.password(), 'secret');
    });

    test(
      'Gmail uses its preset server; custom uses what was entered',
      () async {
        expect(gmail.smtpConfig.host, 'smtp.gmail.com');
        expect(gmail.smtpConfig.port, 465);
        expect(gmail.smtpConfig.security, SmtpSecurity.ssl);

        const custom = EmailAccount(
          provider: EmailProvider.custom,
          address: 'me@example.org',
          host: ' mail.example.org ',
          port: 2525,
          security: SmtpSecurity.startTls,
        );
        await accounts.save(custom, password: 'p w');
        final loaded = (await accounts.load())!;
        expect(loaded.smtpConfig.host, 'mail.example.org');
        expect(loaded.smtpConfig.port, 2525);
        expect(
          await accounts.password(),
          'p w',
          reason: 'only Gmail passwords lose spaces',
        );
      },
    );

    test('custom accounts need a server to be complete', () {
      expect(const EmailAccount(address: 'a@b.co').isComplete, isTrue);
      expect(
        const EmailAccount(
          provider: EmailProvider.custom,
          address: 'a@b.co',
        ).isComplete,
        isFalse,
      );
    });

    test('forget removes the account and its password', () async {
      await accounts.save(gmail, password: 'secret');
      await accounts.forget();
      expect(await accounts.load(), isNull);
      expect(await accounts.hasPassword(), isFalse);
    });
  });

  group('EmailService.sendTest', () {
    test('needs a complete account with a password', () async {
      expect(
        () => service.sendTest(
          subject: 'S',
          body: builtinBody('en'),
          languageCode: 'en',
        ),
        throwsA(isA<AccountNotReadyException>()),
      );
      await accounts.save(gmail);
      expect(
        () => service.sendTest(
          subject: 'S',
          body: builtinBody('en'),
          languageCode: 'en',
        ),
        throwsA(isA<AccountNotReadyException>()),
      );
    });

    test('sends a sample email to the organizer, from the organizer', () async {
      await accounts.save(gmail, password: 'secret');

      final to = await service.sendTest(
        subject: defaultSubject('en'),
        body: builtinBody('en'),
        languageCode: 'en',
      );

      expect(to, 'sam.santa@gmail.com');
      final sent = transport.sent.single;
      expect(sent.to, 'sam.santa@gmail.com');
      expect(sent.password, 'secret');
      expect(sent.config.host, 'smtp.gmail.com');
      expect(sent.config.senderName, 'Sam');
      expect(
        sent.email.subject,
        startsWith('[Test] 🎁 Your Secret Santa assignment for'),
      );
      expect(sent.email.html, contains('Hi Sam,'));
      expect(sent.email.html, contains('Sent by Sam'));
      expect(sent.email.text, contains('Jordan'));
    });

    test('plain-text templates send no HTML part', () async {
      await accounts.save(gmail, password: 'secret');
      await service.sendTest(
        subject: 'Hi',
        body: const BodyTemplate(BodyFormat.text, 'Hello {{GiverName}}'),
        languageCode: 'en',
      );
      expect(transport.sent.single.email.html, isNull);
      expect(transport.sent.single.email.text, 'Hello Sam');
    });

    test('passes sending failures through', () async {
      await accounts.save(gmail, password: 'wrong');
      transport.failWith = const SendException(
        SendFailure.authentication,
        '535 bad',
      );
      expect(
        () => service.sendTest(
          subject: 'S',
          body: builtinBody('en'),
          languageCode: 'en',
        ),
        throwsA(
          isA<SendException>().having(
            (e) => e.failure,
            'failure',
            SendFailure.authentication,
          ),
        ),
      );
    });
  });

  test('messages are multipart: text always, HTML when present', () {
    final message = buildMessage(
      gmail.smtpConfig,
      to: 'ana@example.com',
      toName: 'Ana',
      email: const RenderedEmail(subject: 'S', text: 'T', html: '<p>H</p>'),
    );
    expect(message.subject, 'S');
    expect(message.text, 'T');
    expect(message.html, '<p>H</p>');
    expect(message.recipients.single.toString(), contains('ana@example.com'));
    expect(message.from.toString(), contains('sam.santa@gmail.com'));
    expect(message.from.toString(), contains('Sam'));
  });
}
