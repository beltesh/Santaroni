import 'dart:async';
import 'dart:io';

import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart';

import 'email_renderer.dart';

enum SmtpSecurity {
  /// TLS from the first byte (usually port 465).
  ssl,

  /// Plain connection upgraded with STARTTLS (usually port 587).
  startTls,
}

/// Where and how to connect, without the password.
class SmtpConfig {
  const SmtpConfig({
    required this.host,
    required this.port,
    required this.security,
    required this.username,
    required this.senderName,
  });

  final String host;
  final int port;
  final SmtpSecurity security;

  /// Login name; also used as the sender address.
  final String username;

  /// Display name in the From header.
  final String senderName;
}

enum SendFailure {
  /// Wrong address or password (for Gmail: not an app password).
  authentication,

  /// Couldn't reach the server: offline, wrong host/port, firewall.
  connection,

  /// The server refused this message or recipient.
  rejected,

  other,
}

class SendException implements Exception {
  const SendException(this.failure, this.detail);

  final SendFailure failure;

  /// The underlying error, for the technically curious.
  final String detail;

  @override
  String toString() => 'SendException(${failure.name}): $detail';
}

/// An open connection for sending several emails in a row.
abstract interface class MailSession {
  Future<void> send({
    required String to,
    String? toName,
    required RenderedEmail email,
  });
  Future<void> close();
}

/// Sends email. The real implementation talks SMTP; tests use a fake.
abstract interface class MailTransport {
  /// Sends one email on its own connection.
  Future<void> sendOne(
    SmtpConfig config,
    String password, {
    required String to,
    String? toName,
    required RenderedEmail email,
  });

  /// Opens a connection to reuse for several emails.
  Future<MailSession> open(SmtpConfig config, String password);
}

class SmtpMailTransport implements MailTransport {
  const SmtpMailTransport({this.timeout = const Duration(seconds: 30)});

  final Duration timeout;

  SmtpServer _server(SmtpConfig c, String password) => SmtpServer(
    c.host,
    port: c.port,
    ssl: c.security == SmtpSecurity.ssl,
    username: c.username,
    password: password,
  );

  @override
  Future<void> sendOne(
    SmtpConfig config,
    String password, {
    required String to,
    String? toName,
    required RenderedEmail email,
  }) => _guard(
    () => mailer.send(
      buildMessage(config, to: to, toName: toName, email: email),
      _server(config, password),
      timeout: timeout,
    ),
  );

  @override
  Future<MailSession> open(SmtpConfig config, String password) async =>
      _SmtpSession(
        config,
        mailer.PersistentConnection(
          _server(config, password),
          timeout: timeout,
        ),
      );
}

class _SmtpSession implements MailSession {
  _SmtpSession(this._config, this._connection);

  final SmtpConfig _config;
  final mailer.PersistentConnection _connection;

  @override
  Future<void> send({
    required String to,
    String? toName,
    required RenderedEmail email,
  }) => _guard(
    () => _connection.send(
      buildMessage(_config, to: to, toName: toName, email: email),
    ),
  );

  @override
  Future<void> close() => _connection.close();
}

/// The email as sent: plain text always, plus HTML when the template is
/// HTML (a multipart/alternative message).
mailer.Message buildMessage(
  SmtpConfig config, {
  required String to,
  String? toName,
  required RenderedEmail email,
}) => mailer.Message()
  ..from = mailer.Address(
    config.username,
    config.senderName.trim().isEmpty ? null : config.senderName,
  )
  ..recipients = [mailer.Address(to, toName)]
  ..subject = email.subject
  ..text = email.text
  ..html = email.html;

Future<void> _guard(Future<Object?> Function() action) async {
  try {
    await action();
  } on mailer.SmtpClientAuthenticationException catch (e) {
    throw SendException(SendFailure.authentication, e.message);
  } on mailer.SmtpMessageValidationException catch (e) {
    throw SendException(SendFailure.rejected, e.message);
  } on mailer.SmtpNoGreetingException catch (e) {
    throw SendException(SendFailure.connection, e.message);
  } on mailer.SmtpUnsecureException catch (e) {
    throw SendException(SendFailure.connection, e.message);
  } on mailer.MailerException catch (e) {
    // Gmail answers 5xx for rejected recipients and 535 for bad logins.
    final m = e.message;
    if (RegExp(r'\b535\b|Username and Password not accepted').hasMatch(m)) {
      throw SendException(SendFailure.authentication, m);
    }
    if (RegExp(r'\b55[0-4]\b').hasMatch(m)) {
      throw SendException(SendFailure.rejected, m);
    }
    throw SendException(SendFailure.other, m);
  } on SocketException catch (e) {
    throw SendException(SendFailure.connection, e.message);
  } on HandshakeException catch (e) {
    throw SendException(SendFailure.connection, e.message);
  } on TimeoutException catch (e) {
    throw SendException(SendFailure.connection, e.message ?? 'Timed out');
  }
}
