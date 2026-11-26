import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../data/database.dart';
import '../features/common/format.dart';
import '../features/home/home_screen.dart';
import '../l10n/app_localizations.dart';
import 'providers.dart';
import 'themes.dart';

class SantaroniApp extends ConsumerWidget {
  const SantaroniApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Until the live settings load, use the ones read at startup.
    final initial = ref.watch(initialSettingsProvider);
    final liveLocale = ref.watch(localeProvider);
    final initialLanguage = initial[SettingKeys.languageCode];
    final locale = liveLocale.hasValue
        ? liveLocale.value
        : initialLanguage == null
        ? null
        : Locale(initialLanguage);
    final prefs =
        ref.watch(themePrefsProvider).value ??
        ThemePrefs.fromSettings(initial);

    return MaterialApp(
      onGenerateTitle: (context) =>
          appDisplayName(AppLocalizations.of(context)),
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      theme: prefs.light.data,
      darkTheme: prefs.dark.data,
      themeMode: prefs.mode.mode,
      home: const HomeScreen(),
    );
  }
}
