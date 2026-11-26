import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../core/languages.dart';
import '../../data/database.dart';
import '../../l10n/app_localizations.dart';
import '../templates/templates_screen.dart';
import 'email_account_screen.dart';

const _systemLanguage = 'system';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final current =
        ref.watch(localeProvider).value?.languageCode ?? _systemLanguage;
    final account = ref.watch(emailAccountProvider).value;

    Future<void> select(String? code) => ref
        .read(databaseProvider)
        .setSetting(
          SettingKeys.languageCode,
          code == _systemLanguage ? null : code,
        );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: DropdownButtonFormField<String>(
              key: ValueKey(current),
              initialValue: current,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: l10n.settingsLanguage,
                prefixIcon: const Icon(Icons.language),
              ),
              items: [
                DropdownMenuItem(
                  value: _systemLanguage,
                  child: Text(l10n.languageSystem),
                ),
                // Each language in its own name, so people can find theirs.
                for (final code in supportedLanguages)
                  DropdownMenuItem(
                    value: code,
                    child: Text(languageEndonym(code)),
                  ),
              ],
              onChanged: select,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.manage_accounts_outlined),
            title: Text(l10n.emailAccount),
            subtitle: Text(
              account == null || account.address.isEmpty
                  ? l10n.emailAccountNotSetUp
                  : account.address,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const EmailAccountScreen(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: Text(l10n.emailTemplates),
            subtitle: Text(l10n.emailTemplatesSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const TemplatesScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
