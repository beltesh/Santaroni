import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../features/home/home_screen.dart';
import '../l10n/app_localizations.dart';
import 'providers.dart';
import 'themes.dart';

class SantaroniApp extends ConsumerWidget {
  const SantaroniApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider).value;
    final prefs = ref.watch(themePrefsProvider).value ?? const ThemePrefs();

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
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
