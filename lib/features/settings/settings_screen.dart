import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../data/database.dart';
import '../../l10n/app_localizations.dart';

const _systemLanguage = 'system';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final current =
        ref.watch(localeProvider).value?.languageCode ?? _systemLanguage;

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
        ],
      ),
    );
  }
}
