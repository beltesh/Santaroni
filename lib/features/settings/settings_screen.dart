import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../app/themes.dart';
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
          const _AppearanceSettings(),
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

/// Light/dark mode, plus the dark and light themes to use. Each dropdown
/// only lists themes of its kind; in System mode both are shown, since the
/// app switches between them with the device.
class _AppearanceSettings extends ConsumerWidget {
  const _AppearanceSettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final prefs = ref.watch(themePrefsProvider).value ?? const ThemePrefs();
    final db = ref.read(databaseProvider);

    Widget picker({required bool dark}) {
      final current = dark ? prefs.dark : prefs.light;
      return DropdownButtonFormField<AppTheme>(
        key: ValueKey((dark, current)),
        initialValue: current,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: dark ? l10n.themeDark : l10n.themeLight,
          prefixIcon: Icon(
            dark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
          ),
        ),
        items: [
          for (final t in AppTheme.values.where((t) => t.isDark == dark))
            DropdownMenuItem(
              value: t,
              child: Row(
                children: [
                  Expanded(child: Text(_themeName(l10n, t))),
                  _Swatch(colors: t.swatch),
                ],
              ),
            ),
        ],
        onChanged: (t) {
          if (t == null) return;
          db.setSetting(
            dark ? ThemePrefs.keyDark : ThemePrefs.keyLight,
            t.name,
          );
        },
      );
    }

    final showDark = prefs.mode != AppThemeMode.light;
    final showLight = prefs.mode != AppThemeMode.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<AppThemeMode>(
            segments: [
              ButtonSegment(
                value: AppThemeMode.system,
                icon: const Icon(Icons.brightness_auto_outlined),
                label: Text(l10n.themeModeSystem),
              ),
              ButtonSegment(
                value: AppThemeMode.dark,
                icon: const Icon(Icons.dark_mode_outlined),
                label: Text(l10n.themeModeDark),
              ),
              ButtonSegment(
                value: AppThemeMode.light,
                icon: const Icon(Icons.light_mode_outlined),
                label: Text(l10n.themeModeLight),
              ),
            ],
            selected: {prefs.mode},
            onSelectionChanged: (s) =>
                db.setSetting(ThemePrefs.keyMode, s.first.name),
          ),
          if (showDark) ...[const SizedBox(height: 16), picker(dark: true)],
          if (showLight) ...[const SizedBox(height: 16), picker(dark: false)],
        ],
      ),
    );
  }
}

/// Named themes keep their brand name in every language.
String _themeName(AppLocalizations l10n, AppTheme t) => switch (t) {
  AppTheme.festiveDark => l10n.themeFestiveDark,
  AppTheme.festiveLight => l10n.themeFestiveLight,
  _ => t.brandName!,
};

/// A row of small color dots previewing a theme.
class _Swatch extends StatelessWidget {
  const _Swatch({required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final outline = Theme.of(context).colorScheme.outlineVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final c in colors)
          Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              color: c,
              shape: BoxShape.circle,
              border: Border.all(color: outline),
            ),
          ),
      ],
    );
  }
}
