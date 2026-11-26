import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../core/email/builtin_templates.dart';
import '../../core/email/email_providers.dart';
import '../../core/email/mail_transport.dart';
import '../../core/util/email.dart';
import '../../data/email_account_repository.dart';
import '../../l10n/app_localizations.dart';
import '../common/dialogs.dart';
import 'test_email_action.dart';

/// Sets up the account Santaroni sends emails from.
class EmailAccountScreen extends ConsumerStatefulWidget {
  const EmailAccountScreen({super.key});

  @override
  ConsumerState<EmailAccountScreen> createState() => _EmailAccountScreenState();
}

class _EmailAccountScreenState extends ConsumerState<EmailAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _password = TextEditingController();
  final _host = TextEditingController();
  final _port = TextEditingController(text: '587');
  EmailProvider _provider = EmailProvider.gmail;
  SmtpSecurity _security = SmtpSecurity.startTls;
  bool _hasSavedPassword = false;
  bool _showPassword = false;
  bool _loaded = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(emailAccountRepositoryProvider);
    final account = await repo.load();
    final hasPassword = await repo.hasPassword();
    if (!mounted) return;
    setState(() {
      if (account != null) {
        _provider = account.provider;
        _name.text = account.senderName;
        _address.text = account.address;
        _host.text = account.host;
        _port.text = '${account.port}';
        _security = account.security;
      }
      _hasSavedPassword = hasPassword;
      _loaded = true;
    });
  }

  @override
  void dispose() {
    for (final c in [_name, _address, _password, _host, _port]) {
      c.dispose();
    }
    super.dispose();
  }

  EmailAccount get _account => EmailAccount(
    provider: _provider,
    senderName: _name.text,
    address: _address.text,
    host: _host.text,
    port: int.tryParse(_port.text.trim()) ?? 587,
    security: _security,
  );

  Future<bool> _save({bool quiet = false}) async {
    if (!_formKey.currentState!.validate()) return false;
    final l10n = AppLocalizations.of(context);
    await ref
        .read(emailAccountRepositoryProvider)
        .save(_account, password: _password.text);
    if (!mounted) return false;
    setState(() {
      if (_password.text.isNotEmpty) _hasSavedPassword = true;
      _password.clear();
    });
    if (!quiet) showSnack(context, l10n.accountSaved);
    return true;
  }

  Future<void> _saveAndTest() async {
    setState(() => _busy = true);
    try {
      if (!await _save(quiet: true) || !mounted) return;
      final lang = Localizations.localeOf(context).languageCode == 'es'
          ? 'es'
          : 'en';
      await sendTestEmail(
        context,
        ref,
        subject: defaultSubject(lang),
        body: builtinBody(lang),
        languageCode: lang,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _forget() async {
    final l10n = AppLocalizations.of(context);
    final ok = await confirmDestructive(
      context,
      title: l10n.forgetAccountTitle,
      body: l10n.forgetAccountBody,
      confirmLabel: l10n.forgetAccount,
    );
    if (!ok || !mounted) return;
    await ref.read(emailAccountRepositoryProvider).forget();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (!_loaded) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.emailAccount)),
        body: const SizedBox.shrink(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.emailAccount),
        actions: [
          if (_hasSavedPassword || _address.text.isNotEmpty)
            IconButton(
              tooltip: l10n.forgetAccount,
              icon: const Icon(Icons.logout),
              onPressed: _forget,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<EmailProvider>(
              initialValue: _provider,
              decoration: InputDecoration(
                labelText: l10n.emailProvider,
                prefixIcon: const Icon(Icons.dns_outlined),
              ),
              items: [
                DropdownMenuItem(
                  value: EmailProvider.gmail,
                  child: Text(l10n.providerGmail),
                ),
                DropdownMenuItem(
                  value: EmailProvider.custom,
                  child: Text(l10n.providerCustom),
                ),
              ],
              onChanged: (p) =>
                  setState(() => _provider = p ?? EmailProvider.gmail),
            ),
            const SizedBox(height: 16),
            if (_provider == EmailProvider.gmail) const _GmailHelp(),
            const _SentFolderWarning(),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l10n.senderName,
                helperText: l10n.senderNameHelp,
                helperMaxLines: 2,
                prefixIcon: const Icon(Icons.badge_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _address,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: l10n.senderAddress,
                hintText: _provider == EmailProvider.gmail
                    ? 'you@gmail.com'
                    : null,
                prefixIcon: const Icon(Icons.alternate_email),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l10n.emailRequired;
                if (!isValidEmail(v)) return l10n.emailInvalid;
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _password,
              obscureText: !_showPassword,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: _provider == EmailProvider.gmail
                    ? l10n.appPassword
                    : l10n.password,
                hintText: _hasSavedPassword ? l10n.passwordSavedHint : null,
                helperText: l10n.passwordStorageNote,
                helperMaxLines: 3,
                prefixIcon: const Icon(Icons.key_outlined),
                suffixIcon: IconButton(
                  tooltip: _showPassword ? l10n.hide : l10n.show,
                  icon: Icon(
                    _showPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () =>
                      setState(() => _showPassword = !_showPassword),
                ),
              ),
              validator: (v) => !_hasSavedPassword && (v == null || v.isEmpty)
                  ? l10n.passwordRequired
                  : null,
            ),
            if (_provider.isCustom) ...[
              const SizedBox(height: 24),
              Text(l10n.serverSettings, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _host,
                autocorrect: false,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: l10n.smtpHost,
                  hintText: 'smtp.example.com',
                ),
                validator: (v) => v == null || v.trim().isEmpty
                    ? l10n.smtpHostRequired
                    : null,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: TextFormField(
                      controller: _port,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(labelText: l10n.smtpPort),
                      validator: (v) {
                        final port = int.tryParse(v ?? '');
                        return port == null || port < 1 || port > 65535
                            ? l10n.smtpPortInvalid
                            : null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<SmtpSecurity>(
                      initialValue: _security,
                      isExpanded: true,
                      decoration: InputDecoration(labelText: l10n.smtpSecurity),
                      items: [
                        DropdownMenuItem(
                          value: SmtpSecurity.startTls,
                          child: Text(l10n.securityStartTls),
                        ),
                        DropdownMenuItem(
                          value: SmtpSecurity.ssl,
                          child: Text(l10n.securitySsl),
                        ),
                      ],
                      onChanged: (s) => setState(() {
                        _security = s ?? SmtpSecurity.startTls;
                        // Fill in the usual port for the chosen security.
                        if (_port.text == '587' || _port.text == '465') {
                          _port.text = _security == SmtpSecurity.ssl
                              ? '465'
                              : '587';
                        }
                      }),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 32),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: _busy ? null : _save,
                  icon: const Icon(Icons.check),
                  label: Text(l10n.save),
                ),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _saveAndTest,
                  icon: const Icon(Icons.send_outlined),
                  label: Text(l10n.sendTestEmail),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GmailHelp extends StatelessWidget {
  const _GmailHelp();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.gmailHelpTitle, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Text(l10n.gmailHelpStep1),
            const SizedBox(height: 4),
            Text(l10n.gmailHelpStep2),
            const SizedBox(height: 4),
            SelectableText(
              'https://myaccount.google.com/apppasswords',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 4),
            Text(l10n.gmailHelpStep3),
          ],
        ),
      ),
    );
  }
}

class _SentFolderWarning extends StatelessWidget {
  const _SentFolderWarning();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.tertiaryContainer,
      child: ListTile(
        leading: Icon(
          Icons.visibility_outlined,
          color: scheme.onTertiaryContainer,
        ),
        title: Text(
          l10n.sentFolderWarningTitle,
          style: TextStyle(color: scheme.onTertiaryContainer),
        ),
        subtitle: Text(
          l10n.sentFolderWarningBody,
          style: TextStyle(color: scheme.onTertiaryContainer),
        ),
      ),
    );
  }
}
