import 'package:santaroni/core/email/email_renderer.dart';
import 'package:santaroni/core/email/mail_transport.dart';
import 'package:santaroni/data/email_account_repository.dart';

class MemorySecretStore implements SecretStore {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);
}

class SentEmail {
  SentEmail(this.config, this.password, this.to, this.toName, this.email);

  final SmtpConfig config;
  final String password;
  final String to;
  final String? toName;
  final RenderedEmail email;
}

/// Records emails instead of sending them. Set [failWith] to simulate a
/// failure, or [failFor] to fail only for certain recipients.
class FakeMailTransport implements MailTransport {
  final sent = <SentEmail>[];
  SendException? failWith;
  Map<String, SendException> failFor = {};
  int sessionsOpened = 0;
  int sessionsClosed = 0;

  Future<void> _record(
    SmtpConfig config,
    String password,
    String to,
    String? toName,
    RenderedEmail email,
  ) async {
    final failure = failFor[to] ?? failWith;
    if (failure != null) throw failure;
    sent.add(SentEmail(config, password, to, toName, email));
  }

  @override
  Future<void> sendOne(
    SmtpConfig config,
    String password, {
    required String to,
    String? toName,
    required RenderedEmail email,
  }) => _record(config, password, to, toName, email);

  @override
  Future<MailSession> open(SmtpConfig config, String password) async {
    sessionsOpened++;
    return _FakeSession(this, config, password);
  }
}

class _FakeSession implements MailSession {
  _FakeSession(this._transport, this._config, this._password);

  final FakeMailTransport _transport;
  final SmtpConfig _config;
  final String _password;

  @override
  Future<void> send({
    required String to,
    String? toName,
    required RenderedEmail email,
  }) => _transport._record(_config, _password, to, toName, email);

  @override
  Future<void> close() async => _transport.sessionsClosed++;
}
