import 'mail_transport.dart';

/// Ready-made server settings for common email providers. Only Gmail for
/// now; others can be added here as they get tested.
enum EmailProvider {
  gmail(host: 'smtp.gmail.com', port: 465, security: SmtpSecurity.ssl),

  /// Any other provider: the user enters the server details.
  custom(host: '', port: 587, security: SmtpSecurity.startTls);

  const EmailProvider({
    required this.host,
    required this.port,
    required this.security,
  });

  final String host;
  final int port;
  final SmtpSecurity security;

  bool get isCustom => this == EmailProvider.custom;

  static EmailProvider byName(String? name) =>
      EmailProvider.values.where((p) => p.name == name).firstOrNull ??
      EmailProvider.gmail;
}

/// Google shows app passwords as "abcd efgh ijkl mnop"; the spaces aren't
/// part of the password.
String cleanAppPassword(String input, EmailProvider provider) =>
    provider == EmailProvider.gmail
    ? input.replaceAll(RegExp(r'\s+'), '')
    : input;
