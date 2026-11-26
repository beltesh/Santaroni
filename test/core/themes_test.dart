import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:santaroni/app/themes.dart';

/// WCAG contrast ratio between two opaque colors (1 to 21).
double contrast(Color a, Color b) {
  double lum(Color c) {
    double ch(double v) =>
        v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
    return 0.2126 * ch(c.r) + 0.7152 * ch(c.g) + 0.0722 * ch(c.b);
  }

  final la = lum(a), lb = lum(b);
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  for (final theme in AppTheme.values) {
    group(theme.name, () {
      final data = theme.data;
      final scheme = data.colorScheme;
      final status = data.extension<StatusPalette>();

      test('is ${theme.brightness.name} and has status colors', () {
        expect(scheme.brightness, theme.brightness);
        expect(status, isNotNull);
      });

      test('text is readable', () {
        final card = scheme.surfaceContainerLow;
        for (final (name, fg, bg) in [
          ('text', scheme.onSurface, scheme.surface),
          ('secondary text', scheme.onSurfaceVariant, scheme.surface),
          ('secondary text on cards', scheme.onSurfaceVariant, card),
          ('primary text on cards', scheme.primary, card),
          ('on primary', scheme.onPrimary, scheme.primary),
          ('on primary container', scheme.onPrimaryContainer, scheme.primaryContainer),
          ('on secondary container', scheme.onSecondaryContainer, scheme.secondaryContainer),
          ('on error container', scheme.onErrorContainer, scheme.errorContainer),
        ]) {
          expect(contrast(fg, bg), greaterThanOrEqualTo(4.5), reason: name);
        }
      });

      test('status cards and the send button are readable', () {
        for (final (name, c) in [
          ('warning', status!.warning),
          ('success', status.success),
          ('go', status.go),
        ]) {
          expect(contrast(c.foreground, c.background), greaterThanOrEqualTo(4.5), reason: name);
        }
      });

      if (!theme.isDark) {
        test('cards stand out from the page', () {
          final card = data.cardTheme.color ?? scheme.surfaceContainerLow;
          // Cards are lighter than the page and have a visible edge.
          expect(card.computeLuminance(), greaterThan(scheme.surface.computeLuminance()));
          final shape = data.cardTheme.shape! as RoundedRectangleBorder;
          expect(shape.side.style, BorderStyle.solid);
          expect(contrast(shape.side.color, card), greaterThanOrEqualTo(1.3));
        });
      }
    });
  }

  test('Festive Light uses real festive red and green on warm cream', () {
    final scheme = AppTheme.festiveLight.data.colorScheme;
    expect(scheme.primary, const Color(0xFFC62828));
    expect(scheme.secondary, const Color(0xFF2E7D32));
    expect(scheme.surface, const Color(0xFFF6F1EA));
  });

  test('palettes match their official colors', () {
    expect(AppTheme.catppuccinMocha.data.colorScheme.surface, const Color(0xFF1E1E2E));
    expect(AppTheme.catppuccinMocha.data.colorScheme.primary, const Color(0xFFCBA6F7));
    expect(AppTheme.catppuccinMacchiato.data.colorScheme.surface, const Color(0xFF24273A));
    expect(AppTheme.catppuccinFrappe.data.colorScheme.surface, const Color(0xFF303446));
    expect(AppTheme.catppuccinLatte.data.colorScheme.surface, const Color(0xFFEFF1F5));
    expect(AppTheme.dracula.data.colorScheme.surface, const Color(0xFF282A36));
    expect(AppTheme.dracula.data.colorScheme.primary, const Color(0xFFBD93F9));
    expect(AppTheme.alucard.data.colorScheme.surface, const Color(0xFFFFFBEB));
    expect(AppTheme.vesper.data.colorScheme.surface, const Color(0xFF101010));
    expect(AppTheme.vesper.data.colorScheme.primary, const Color(0xFF99FFE4)); // mint
    expect(AppTheme.poimandres.data.colorScheme.primary, const Color(0xFF5DE4C7)); // mint
  });

  test('every theme has a name, and each group has themes', () {
    for (final t in AppTheme.values) {
      expect(t.brandName != null || t.name.startsWith('festive'), isTrue, reason: t.name);
    }
    expect(AppTheme.values.where((t) => t.isDark), isNotEmpty);
    expect(AppTheme.values.where((t) => !t.isDark), isNotEmpty);
  });

  group('ThemePrefs', () {
    test('first run follows the system with the festive pair', () {
      final p = ThemePrefs.fromSettings({});
      expect((p.mode, p.dark, p.light),
          (AppThemeMode.system, AppTheme.festiveDark, AppTheme.festiveLight));
    });

    test('reads the saved mode and picks', () {
      final p = ThemePrefs.fromSettings({
        ThemePrefs.keyMode: 'dark',
        ThemePrefs.keyDark: 'vesper',
        ThemePrefs.keyLight: 'alucard',
      });
      expect((p.mode, p.dark, p.light), (AppThemeMode.dark, AppTheme.vesper, AppTheme.alucard));
    });

    test('a pick on the wrong side falls back to festive', () {
      final p = ThemePrefs.fromSettings({
        ThemePrefs.keyDark: 'catppuccinLatte',
        ThemePrefs.keyLight: 'dracula',
      });
      expect((p.dark, p.light), (AppTheme.festiveDark, AppTheme.festiveLight));
    });

    test('older single-theme setting becomes the pick for its side', () {
      final vesper = ThemePrefs.fromSettings({ThemePrefs.keyLegacyTheme: 'vesper'});
      expect((vesper.dark, vesper.light), (AppTheme.vesper, AppTheme.festiveLight));
      final latte = ThemePrefs.fromSettings({ThemePrefs.keyLegacyTheme: 'catppuccinLatte'});
      expect((latte.dark, latte.light), (AppTheme.festiveDark, AppTheme.catppuccinLatte));
    });

    test('older theme families map to both sides, keeping the mode', () {
      final p = ThemePrefs.fromSettings({
        ThemePrefs.keyLegacyTheme: 'dracula',
        ThemePrefs.keyMode: 'light',
      });
      expect((p.mode, p.dark, p.light), (AppThemeMode.light, AppTheme.dracula, AppTheme.alucard));
    });

    test('new picks win over older settings', () {
      final p = ThemePrefs.fromSettings({
        ThemePrefs.keyLegacyTheme: 'catppuccin',
        ThemePrefs.keyDark: 'poimandres',
      });
      expect((p.dark, p.light), (AppTheme.poimandres, AppTheme.catppuccinLatte));
    });
  });
}
