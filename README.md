# Santaroni

A privacy-friendly Secret Santa organizer for Windows and Android.

There's no hosted service and no third party holding anyone's email address.
The organizer connects their own email account, and Santaroni sends each
participant their assignment directly over SMTP.

## Download

Get the latest version from the
[Releases page](https://github.com/beltesh/Santaroni/releases):

- **Windows 10/11:** the `windows-setup.exe` installer (no admin rights
  needed), or the `windows-portable.zip` to unzip and run anywhere.
- **Android 7+:** the `android-arm64.apk` for most phones, or the universal
  `android.apk`. Android asks you to allow installing apps from your browser
  or file manager the first time.

## Features

- Events with optional date, time, place and gift budget (with currency).
- Participants added by hand or imported from CSV, each with an optional wishlist.
- Assignments always form one single loop through everyone, with optional
  exclusion groups (e.g. couples never draw each other).
- Assignments are hidden by default, so the organizer can take part too.
- Festive HTML emails, or your own templates (assignment and cancellation).
- Resumable sending with per-participant retry and "resend".
- Cancelling an event emails everyone, with an optional note.
- English, Mexican Spanish and Brazilian Portuguese; dark and light themes.

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

Releases are built by GitHub Actions when a version tag is pushed; see
[docs/RELEASING.md](docs/RELEASING.md).

## Project layout

```
lib/
  app/        App widget, theme, Riverpod providers
  core/       Pure Dart logic (assignment algorithm, formatting helpers)
  data/       Drift (SQLite) schema and queries
  features/   Screens, one folder per feature
  l10n/       Translations
test/         Unit tests mirroring lib/
installer/    Windows installer (Inno Setup) and packaging script
.github/      CI and release workflows
```

## License

Santaroni is free software, licensed under the
[GNU General Public License v3.0](LICENSE). You can use, study, share and
modify it; if you distribute a modified version, you must release its source
code under the same license.
