import 'package:material_ui/material_ui.dart';

/// The color themes the user can pick. Each is either light or dark, exactly
/// as its authors designed it (no invented light/dark counterparts).
enum AppTheme {
  /// Festive reds and greens on a dark background. The default.
  festiveDark(Brightness.dark),

  /// Festive red and green on warm cream, matching the built-in email.
  festiveLight(Brightness.light),

  // Catppuccin (https://catppuccin.com/palette), Mauve accent.
  catppuccinMocha(Brightness.dark, 'Catppuccin Mocha'),
  catppuccinMacchiato(Brightness.dark, 'Catppuccin Macchiato'),
  catppuccinFrappe(Brightness.dark, 'Catppuccin Frappé'),
  catppuccinLatte(Brightness.light, 'Catppuccin Latte'),

  // Dracula and its light companion (https://draculatheme.com/spec).
  dracula(Brightness.dark, 'Dracula'),
  alucard(Brightness.light, 'Alucard'),

  /// Near-black with mint and peach (Vesper, by Rauno Freiberg).
  vesper(Brightness.dark, 'Vesper'),

  /// Deep blue-black with mint (Poimandres, by drcmda).
  poimandres(Brightness.dark, 'Poimandres');

  const AppTheme(this.brightness, [this.brandName]);

  final Brightness brightness;

  /// The theme's own name, shown as-is in every language. Null for the
  /// Festive themes, whose names are translated.
  final String? brandName;

  bool get isDark => brightness == Brightness.dark;

  static AppTheme? byName(String? name) =>
      values.where((t) => t.name == name).firstOrNull;

  /// Built once per theme and reused: rebuilding on every app rebuild
  /// made Flutter see a "new" theme and replay its transition animation
  /// whenever any setting changed.
  ThemeData get data => _cache.putIfAbsent(this, () => _build());

  static final _cache = <AppTheme, ThemeData>{};

  ThemeData _build() => switch (this) {
    festiveDark => _festiveDark(),
    festiveLight => _fromPalette(_festiveLightPalette),
    catppuccinMocha => _fromPalette(_mocha),
    catppuccinMacchiato => _fromPalette(_macchiato),
    catppuccinFrappe => _fromPalette(_frappe),
    catppuccinLatte => _fromPalette(_latte),
    dracula => _fromPalette(_dracula),
    alucard => _fromPalette(_alucard),
    vesper => _fromPalette(_vesper),
    poimandres => _fromPalette(_poimandres),
  };

  /// A few representative colors, for previews in the theme picker.
  List<Color> get swatch {
    final theme = data;
    return [
      theme.colorScheme.surface,
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.extension<StatusPalette>()!.go.background,
    ];
  }
}

/// Whether the app is dark, light, or follows the system setting.
enum AppThemeMode {
  system(ThemeMode.system),
  dark(ThemeMode.dark),
  light(ThemeMode.light);

  const AppThemeMode(this.mode);
  final ThemeMode mode;

  static AppThemeMode byName(String? name) =>
      values.where((m) => m.name == name).firstOrNull ?? system;
}

/// The user's appearance choices: a mode, plus one dark and one light
/// theme. In system mode the app switches between the two on its own.
class ThemePrefs {
  const ThemePrefs({
    this.mode = AppThemeMode.system,
    this.dark = AppTheme.festiveDark,
    this.light = AppTheme.festiveLight,
  });

  final AppThemeMode mode;
  final AppTheme dark;
  final AppTheme light;

  static const keyMode = 'app.themeMode';
  static const keyDark = 'app.darkTheme';
  static const keyLight = 'app.lightTheme';

  /// Older versions stored a single theme here.
  static const keyLegacyTheme = 'app.theme';

  /// Reads the choices from the settings table's key/value pairs, also
  /// understanding older settings:
  /// - a single theme ("vesper", "catppuccinLatte"), which becomes the pick
  ///   for its side;
  /// - a theme family plus a mode ("dracula" + "light" meant Alucard).
  factory ThemePrefs.fromSettings(Map<String, String> values) {
    final mode = AppThemeMode.byName(values[keyMode]);
    var dark = AppTheme.byName(values[keyDark]);
    var light = AppTheme.byName(values[keyLight]);

    final legacy = values[keyLegacyTheme];
    if (legacy != null) {
      final family = switch (legacy) {
        'festive' => (AppTheme.festiveDark, AppTheme.festiveLight),
        'catppuccin' => (AppTheme.catppuccinMocha, AppTheme.catppuccinLatte),
        'dracula' => (AppTheme.dracula, AppTheme.alucard),
        _ => null,
      };
      if (family != null) {
        dark ??= family.$1;
        light ??= family.$2;
      } else if (AppTheme.byName(legacy) case final single?) {
        if (single.isDark) {
          dark ??= single;
        } else {
          light ??= single;
        }
      }
    }

    // Guard against a light theme saved as the dark pick, or vice versa.
    return ThemePrefs(
      mode: mode,
      dark: dark != null && dark.isDark ? dark : AppTheme.festiveDark,
      light: light != null && !light.isDark ? light : AppTheme.festiveLight,
    );
  }
}

/// Background/foreground pair for status cards, banners and buttons.
class StatusColors {
  const StatusColors(this.background, this.foreground);

  final Color background;
  final Color foreground;

  static StatusColors? lerp(StatusColors? a, StatusColors? b, double t) =>
      a == null || b == null
      ? b
      : StatusColors(
          Color.lerp(a.background, b.background, t)!,
          Color.lerp(a.foreground, b.foreground, t)!,
        );

  /// Amber: something needs the user's attention.
  static StatusColors warning(BuildContext context) => _of(context).warning;

  /// Green: all set.
  static StatusColors success(BuildContext context) => _of(context).success;

  /// Solid green for the one action that's ready to go, meant to stand out
  /// from everything else on screen.
  static StatusColors go(BuildContext context) => _of(context).go;

  static StatusPalette _of(BuildContext context) =>
      Theme.of(context).extension<StatusPalette>() ?? _festiveDarkStatus;
}

/// The status colors each theme brings along. Material's color scheme has
/// no "warning" or "success" roles, so themes define them here.
class StatusPalette extends ThemeExtension<StatusPalette> {
  const StatusPalette({
    required this.warning,
    required this.success,
    required this.go,
  });

  final StatusColors warning;
  final StatusColors success;
  final StatusColors go;

  @override
  StatusPalette copyWith({
    StatusColors? warning,
    StatusColors? success,
    StatusColors? go,
  }) => StatusPalette(
    warning: warning ?? this.warning,
    success: success ?? this.success,
    go: go ?? this.go,
  );

  @override
  StatusPalette lerp(StatusPalette? other, double t) => other == null
      ? this
      : StatusPalette(
          warning: StatusColors.lerp(warning, other.warning, t)!,
          success: StatusColors.lerp(success, other.success, t)!,
          go: StatusColors.lerp(go, other.go, t)!,
        );
}

// --- Festive Dark -----------------------------------------------------------

/// Derived from festive red by Material's color system.
ThemeData _festiveDark() => ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFC62828),
    brightness: Brightness.dark,
  ),
  extensions: const [_festiveDarkStatus],
);

const _festiveDarkStatus = StatusPalette(
  warning: StatusColors(Color(0xFF4A3000), Color(0xFFFFDDB3)),
  success: StatusColors(Color(0xFF1E3A1F), Color(0xFFBFE8BC)),
  go: StatusColors(Color(0xFF7BD17F), Color(0xFF0A2E0C)),
);

// --- Palette-based themes ---------------------------------------------------

/// The colors a palette-based theme provides. Most published themes have
/// this shape: a few background shades, text shades, and named accents.
class _Palette {
  const _Palette({
    required this.brightness,
    required this.base,
    required this.mantle,
    required this.crust,
    required this.surface0,
    required this.surface1,
    required this.surface2,
    required this.text,
    required this.subtext,
    required this.outline,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.error,
    required this.warning,
    required this.warningText,
    required this.success,
    this.inkDarken = 0,
  });

  final Brightness brightness;

  /// Main background, then progressively darker shades of it.
  final Color base, mantle, crust;

  /// Raised surfaces (menus, dialogs), from subtle to strong.
  final Color surface0, surface1, surface2;

  /// Main and secondary text.
  final Color text, subtext;
  final Color outline;
  final Color primary, secondary, tertiary, error;

  /// Warning background accent, and the readable text color for it.
  final Color warning, warningText;
  final Color success;

  /// How much to darken accents when used as text on light backgrounds
  /// (bright palettes like Catppuccin Latte need it).
  final double inkDarken;

  bool get isDark => brightness == Brightness.dark;
}

ThemeData _fromPalette(_Palette p) {
  final dark = p.isDark;
  // Containers are the accent mixed into the background, so they keep the
  // palette's hue without fighting the text color.
  Color tint(Color accent, double amount) =>
      Color.lerp(p.base, accent, amount)!;
  // Accents used as text on light backgrounds may need darkening.
  Color ink(Color accent) =>
      dark ? accent : Color.lerp(accent, Colors.black, p.inkDarken)!;
  final onAccent = dark ? p.crust : Colors.white;
  // Light themes: near-white cards on the tinted page, so sections stand
  // out (Material's default light cards are almost the page color).
  final card = dark ? p.mantle : Color.lerp(p.base, Colors.white, 0.85)!;

  final scheme = ColorScheme(
    brightness: p.brightness,
    primary: p.primary,
    onPrimary: onAccent,
    primaryContainer: tint(p.primary, dark ? 0.28 : 0.18),
    onPrimaryContainer: dark ? p.text : ink(p.primary),
    secondary: p.secondary,
    onSecondary: onAccent,
    secondaryContainer: tint(p.secondary, dark ? 0.24 : 0.2),
    onSecondaryContainer: dark ? p.text : ink(p.secondary),
    tertiary: p.tertiary,
    onTertiary: onAccent,
    tertiaryContainer: tint(p.tertiary, dark ? 0.24 : 0.18),
    onTertiaryContainer: dark ? p.text : ink(p.tertiary),
    error: p.error,
    onError: onAccent,
    errorContainer: tint(p.error, dark ? 0.24 : 0.15),
    onErrorContainer: dark ? p.text : ink(p.error),
    surface: p.base,
    onSurface: p.text,
    onSurfaceVariant: p.subtext,
    surfaceContainerLowest: dark ? p.crust : Colors.white,
    surfaceContainerLow: card,
    surfaceContainer: dark ? Color.lerp(p.base, p.surface0, 0.5)! : p.mantle,
    surfaceContainerHigh: dark ? p.surface0 : p.crust,
    surfaceContainerHighest: dark ? p.surface1 : p.surface0,
    outline: p.outline,
    outlineVariant: p.surface2,
    inverseSurface: p.text,
    onInverseSurface: p.base,
    inversePrimary: p.primary,
    surfaceTint: p.primary,
    shadow: Colors.black,
    scrim: Colors.black,
  );

  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: p.base,
    cardTheme: CardThemeData(
      color: card,
      surfaceTintColor: Colors.transparent,
      // A thin edge on light themes; dark themes separate by shade.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: dark ? BorderSide.none : BorderSide(color: p.surface1),
      ),
    ),
    extensions: [
      StatusPalette(
        warning: StatusColors(
          tint(p.warning, dark ? 0.16 : 0.25),
          ink(p.warningText),
        ),
        success: StatusColors(
          tint(p.success, dark ? 0.16 : 0.2),
          ink(p.success),
        ),
        // Solid green with dark text when dark; a deep green with white
        // text when light (bright greens are too light for white text).
        go: dark
            ? StatusColors(p.success, p.crust)
            : StatusColors(
                Color.lerp(p.success, Colors.black, p.inkDarken)!,
                Colors.white,
              ),
      ),
    ],
  );
}

// --- Festive Light ----------------------------------------------------------

/// Hand-tuned rather than derived: Material's generated light scheme came
/// out salmon-pink with cards that blended into the page.
const _festiveLightPalette = _Palette(
  brightness: Brightness.light,
  base: Color(0xFFF6F1EA), // the built-in email's page color
  mantle: Color(0xFFEEE7DE),
  crust: Color(0xFFE5DCD0),
  surface0: Color(0xFFDDD3C6),
  surface1: Color(0xFFD3C7B8),
  surface2: Color(0xFFBFB3A4),
  text: Color(0xFF2B2421),
  subtext: Color(0xFF5E5550),
  outline: Color(0xFF8C8177),
  primary: Color(0xFFC62828), // festive red
  secondary: Color(0xFF2E7D32), // festive green
  tertiary: Color(0xFF9A6B00), // gold
  error: Color(0xFFB3261E),
  warning: Color(0xFFF0A020),
  warningText: Color(0xFF8A5A00),
  success: Color(0xFF2E7D32),
  inkDarken: 0.2,
);

// --- Catppuccin (https://catppuccin.com/palette) ---------------------------

const _latte = _Palette(
  brightness: Brightness.light,
  base: Color(0xFFEFF1F5),
  mantle: Color(0xFFE6E9EF),
  crust: Color(0xFFDCE0E8),
  surface0: Color(0xFFCCD0DA),
  surface1: Color(0xFFBCC0CC),
  surface2: Color(0xFFACB0BE),
  text: Color(0xFF4C4F69),
  // subtext1: Latte's subtext0 is just under 4.5:1 on its base.
  subtext: Color(0xFF5C5F77),
  outline: Color(0xFF9CA0B0), // overlay0
  primary: Color(0xFF8839EF), // mauve
  secondary: Color(0xFFEA76CB), // pink
  tertiary: Color(0xFF179299), // teal
  error: Color(0xFFD20F39), // red
  warning: Color(0xFFDF8E1D), // yellow
  warningText: Color(0xFFFE640B), // peach
  success: Color(0xFF40A02B), // green
  inkDarken: 0.42,
);

const _frappe = _Palette(
  brightness: Brightness.dark,
  base: Color(0xFF303446),
  mantle: Color(0xFF292C3C),
  crust: Color(0xFF232634),
  surface0: Color(0xFF414559),
  surface1: Color(0xFF51576D),
  surface2: Color(0xFF626880),
  text: Color(0xFFC6D0F5),
  subtext: Color(0xFFA5ADCE), // subtext0
  outline: Color(0xFF737994), // overlay0
  primary: Color(0xFFCA9EE6), // mauve
  secondary: Color(0xFFF4B8E4), // pink
  tertiary: Color(0xFF81C8BE), // teal
  error: Color(0xFFE78284), // red
  // Yellow text on a peach tint reads better than peach on yellow.
  warning: Color(0xFFEF9F76), // peach
  warningText: Color(0xFFE5C890), // yellow
  success: Color(0xFFA6D189), // green
);

const _macchiato = _Palette(
  brightness: Brightness.dark,
  base: Color(0xFF24273A),
  mantle: Color(0xFF1E2030),
  crust: Color(0xFF181926),
  surface0: Color(0xFF363A4F),
  surface1: Color(0xFF494D64),
  surface2: Color(0xFF5B6078),
  text: Color(0xFFCAD3F5),
  subtext: Color(0xFFA5ADCB), // subtext0
  outline: Color(0xFF6E738D), // overlay0
  primary: Color(0xFFC6A0F6), // mauve
  secondary: Color(0xFFF5BDE6), // pink
  tertiary: Color(0xFF8BD5CA), // teal
  error: Color(0xFFED8796), // red
  // Yellow text on a peach tint reads better than peach on yellow.
  warning: Color(0xFFF5A97F), // peach
  warningText: Color(0xFFEED49F), // yellow
  success: Color(0xFFA6DA95), // green
);

const _mocha = _Palette(
  brightness: Brightness.dark,
  base: Color(0xFF1E1E2E),
  mantle: Color(0xFF181825),
  crust: Color(0xFF11111B),
  surface0: Color(0xFF313244),
  surface1: Color(0xFF45475A),
  surface2: Color(0xFF585B70),
  text: Color(0xFFCDD6F4),
  subtext: Color(0xFFA6ADC8), // subtext0
  outline: Color(0xFF6C7086), // overlay0
  primary: Color(0xFFCBA6F7), // mauve
  secondary: Color(0xFFF5C2E7), // pink
  tertiary: Color(0xFF94E2D5), // teal
  error: Color(0xFFF38BA8), // red
  // Yellow text on a peach tint reads better than peach on yellow.
  warning: Color(0xFFFAB387), // peach
  warningText: Color(0xFFF9E2AF), // yellow
  success: Color(0xFFA6E3A1), // green
);

// --- Dracula / Alucard (https://draculatheme.com/spec) ---------------------

const _dracula = _Palette(
  brightness: Brightness.dark,
  base: Color(0xFF282A36), // background
  mantle: Color(0xFF21222C),
  crust: Color(0xFF191A21),
  surface0: Color(0xFF343746),
  surface1: Color(0xFF44475A), // current line / selection
  surface2: Color(0xFF565B78),
  text: Color(0xFFF8F8F2), // foreground
  // Dracula's comment color (#6272A4) is too dim for body text, so
  // secondary text leans towards the foreground.
  subtext: Color(0xFFBDC1D6),
  outline: Color(0xFF6272A4), // comment
  primary: Color(0xFFBD93F9), // purple
  secondary: Color(0xFFFF79C6), // pink
  tertiary: Color(0xFF8BE9FD), // cyan
  error: Color(0xFFFF5555), // red
  // Bright yellow reads better as text on an orange tint than the reverse.
  warning: Color(0xFFFFB86C), // orange
  warningText: Color(0xFFF1FA8C), // yellow
  success: Color(0xFF50FA7B), // green
);

const _alucard = _Palette(
  brightness: Brightness.light,
  base: Color(0xFFFFFBEB), // background
  mantle: Color(0xFFF5F1DE),
  crust: Color(0xFFECE7D2),
  surface0: Color(0xFFE2DCC5),
  surface1: Color(0xFFCFCFDE), // selection
  surface2: Color(0xFFBCBAA6),
  text: Color(0xFF1F1F1F), // foreground
  subtext: Color(0xFF5B5640),
  outline: Color(0xFF6C664B), // comment
  primary: Color(0xFF644AC9), // purple
  secondary: Color(0xFFA3144D), // pink
  tertiary: Color(0xFF036A96), // cyan
  error: Color(0xFFCB3A2A), // red
  warning: Color(0xFF846E15), // yellow
  warningText: Color(0xFFA34D14), // orange
  success: Color(0xFF14710A), // green
  // Alucard's accents are close to 4.5:1 on its tinted backgrounds.
  inkDarken: 0.25,
);

// --- Vesper -----------------------------------------------------------------

/// Near-black with mint and peach. Mint leads here (it's what "ready"
/// and the main accent use); peach is the secondary accent.
const _vesper = _Palette(
  brightness: Brightness.dark,
  base: Color(0xFF101010),
  mantle: Color(0xFF0B0B0B),
  crust: Color(0xFF050505),
  surface0: Color(0xFF1C1C1C),
  surface1: Color(0xFF282828),
  surface2: Color(0xFF343434),
  text: Color(0xFFFFFFFF),
  subtext: Color(0xFFA0A0A0),
  outline: Color(0xFF505050),
  primary: Color(0xFF99FFE4), // mint
  secondary: Color(0xFFFFC799), // peach
  tertiary: Color(0xFFFFCFA8),
  error: Color(0xFFFF8080),
  warning: Color(0xFFFFC799),
  warningText: Color(0xFFFFC799),
  success: Color(0xFF99FFE4),
);

// --- Poimandres -------------------------------------------------------------

/// Deep blue-black with mint as the star.
const _poimandres = _Palette(
  brightness: Brightness.dark,
  base: Color(0xFF1B1E28),
  mantle: Color(0xFF171922),
  crust: Color(0xFF12141B),
  surface0: Color(0xFF252B37),
  surface1: Color(0xFF303340),
  surface2: Color(0xFF3E4457),
  text: Color(0xFFE4F0FB),
  subtext: Color(0xFFA6ACCD),
  outline: Color(0xFF767C9D),
  primary: Color(0xFF5DE4C7), // mint
  secondary: Color(0xFFADD7FF), // light blue
  tertiary: Color(0xFFFCC5E9), // pink
  error: Color(0xFFD0679D), // hot red
  warning: Color(0xFFFFFAC2), // yellow
  warningText: Color(0xFFFFFAC2),
  success: Color(0xFF5DE4C7),
);
