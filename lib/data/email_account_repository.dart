import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/email/email_providers.dart';
import '../core/email/mail_transport.dart';
import 'database.dart';

/// The organizer's sending account. Everything except the password lives in
/// the settings table; the password goes to the OS keychain.
class EmailAccount {
  const EmailAccount({
    this.provider = EmailProvider.gmail,
    this.senderName = '',
    this.address = '',
    this.host = '',
    this.port = 587,
    this.security = SmtpSecurity.startTls,
  });

  final EmailProvider provider;

  /// Shown as the sender, and used for `{{OrganizerName}}`.
  final String senderName;
  final String address;

  /// Only used for [EmailProvider.custom]; presets bring their own.
  final String host;
  final int port;
  final SmtpSecurity security;

  bool get isComplete =>
      address.trim().isNotEmpty &&
      (!provider.isCustom || host.trim().isNotEmpty);

  SmtpConfig get smtpConfig => SmtpConfig(
    host: provider.isCustom ? host.trim() : provider.host,
    port: provider.isCustom ? port : provider.port,
    security: provider.isCustom ? security : provider.security,
    username: address.trim(),
    senderName: senderName.trim(),
  );
}

class AccountStatus {
  const AccountStatus(this.account, this.hasPassword);

  final EmailAccount? account;
  final bool hasPassword;

  /// Address, server and password are all set.
  bool get isReady => account != null && account!.isComplete && hasPassword;
}

/// Minimal key/value secret store, so tests can avoid the real keychain.
abstract interface class SecretStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

class KeychainSecretStore implements SecretStore {
  const KeychainSecretStore([this._storage = const FlutterSecureStorage()]);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

class EmailAccountRepository {
  EmailAccountRepository(this._db, this._secrets);

  final AppDatabase _db;
  final SecretStore _secrets;

  static const _passwordKey = 'santaroni.smtp.password';
  static const _keys = [
    SettingKeys.smtpPreset,
    SettingKeys.senderName,
    SettingKeys.smtpUsername,
    SettingKeys.smtpHost,
    SettingKeys.smtpPort,
    SettingKeys.smtpSecurity,
  ];

  Stream<EmailAccount?> watch() => _db.select(_db.settings).watch().map((rows) {
    final values = {for (final r in rows) r.key: r.value};
    return _fromValues(values);
  });

  Future<EmailAccount?> load() => watch().first;

  /// Whether the account can send. Saving or forgetting always rewrites the
  /// settings rows, so the password check re-runs whenever it may change.
  Stream<AccountStatus> watchStatus() =>
      watch().asyncMap((a) async => AccountStatus(a, await hasPassword()));

  Future<AccountStatus> status() => watchStatus().first;

  EmailAccount? _fromValues(Map<String, String> v) {
    final address = v[SettingKeys.smtpUsername];
    if (address == null) return null;
    return EmailAccount(
      provider: EmailProvider.byName(v[SettingKeys.smtpPreset]),
      senderName: v[SettingKeys.senderName] ?? '',
      address: address,
      host: v[SettingKeys.smtpHost] ?? '',
      port: int.tryParse(v[SettingKeys.smtpPort] ?? '') ?? 587,
      security:
          SmtpSecurity.values
              .where((s) => s.name == v[SettingKeys.smtpSecurity])
              .firstOrNull ??
          SmtpSecurity.startTls,
    );
  }

  /// Saves the account. A null or empty [password] keeps the stored one.
  Future<void> save(EmailAccount account, {String? password}) async {
    await _db.transaction(() async {
      await _db.setSetting(SettingKeys.smtpPreset, account.provider.name);
      await _db.setSetting(SettingKeys.senderName, account.senderName.trim());
      await _db.setSetting(SettingKeys.smtpUsername, account.address.trim());
      await _db.setSetting(SettingKeys.smtpHost, account.host.trim());
      await _db.setSetting(SettingKeys.smtpPort, '${account.port}');
      await _db.setSetting(SettingKeys.smtpSecurity, account.security.name);
    });
    if (password != null && password.isNotEmpty) {
      await _secrets.write(
        _passwordKey,
        cleanAppPassword(password, account.provider),
      );
    }
  }

  Future<String?> password() => _secrets.read(_passwordKey);

  Future<bool> hasPassword() async => (await password())?.isNotEmpty ?? false;

  /// Removes the account and its password from this device.
  Future<void> forget() async {
    for (final key in _keys) {
      await _db.setSetting(key, null);
    }
    await _secrets.delete(_passwordKey);
  }
}
