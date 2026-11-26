import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
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
          ListTile(
            title: Text(
              l10n.settingsLanguage,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          RadioGroup<String>(
            groupValue: current,
            onChanged: select,
            child: Column(
              children: [
                RadioListTile(
                  value: _systemLanguage,
                  title: Text(l10n.languageSystem),
                ),
                RadioListTile(value: 'en', title: Text(l10n.languageEnglish)),
                RadioListTile(value: 'es', title: Text(l10n.languageSpanish)),
              ],
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
