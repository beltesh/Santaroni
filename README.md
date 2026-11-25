# Santaroni

A privacy-friendly Secret Santa organizer for Windows and Android.

There's no hosted service and no third party holding anyone's email address.
The organizer connects their own email account, and Santaroni sends each
participant their assignment directly over SMTP.

## Features (in progress)

- Events with optional date, time, place and gift budget (with currency).
- Participants added by hand or imported from CSV, each with an optional wishlist.
- Assignments always form one single loop through everyone, with optional
  exclusion groups (e.g. couples never draw each other).
- Assignments are hidden by default, so the organizer can take part too.
- Customizable HTML email templates.
- Resumable sending with per-participant retry and "resend".
- English and Spanish interface.

## Development

Requires Flutter (stable) with the Windows and/or Android toolchains.

```sh
flutter pub get
dart run build_runner build   # regenerate drift database code after schema changes
flutter test
flutter run -d windows
```

Translations live in `lib/l10n/app_*.arb`; Flutter regenerates the Dart
classes automatically on build (or run `flutter gen-l10n`).

## Project layout

```
lib/
  app/        App widget, theme, Riverpod providers
  core/       Pure Dart logic (assignment algorithm, formatting helpers)
  data/       Drift (SQLite) schema and queries
  features/   Screens, one folder per feature
  l10n/       Translations
test/         Unit tests mirroring lib/
```

## License

Santaroni is free software, licensed under the
[GNU General Public License v3.0](LICENSE). You can use, study, share and
modify it; if you distribute a modified version, you must release its source
code under the same license.
