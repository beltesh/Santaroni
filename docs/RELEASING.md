# Releasing Santaroni

Pushing a version tag makes GitHub Actions
([release.yml](../.github/workflows/release.yml)) test the app, build every
package and create a **draft** release with them:

| File | What it is |
|---|---|
| `Santaroni-<version>-windows-setup.exe` | Windows installer (per-user by default, no admin needed) |
| `Santaroni-<version>-windows-portable.zip` | The same app, unzip and run `santaroni.exe` |
| `Santaroni-<version>-android-arm64.apk` | Android, 64-bit ARM phones (most phones, about 22 MB) |
| `Santaroni-<version>-android.apk` | Android, any device (about 63 MB) |
| `SHA256SUMS.txt` | Checksums of the files above |

## One-time setup

### 1. Create the Android signing key

Android only installs an update if it's signed with the same key as the
installed app, so this key signs every release, forever. **If it's lost,
existing users can't update** (they'd have to uninstall, losing their data);
if it leaks, someone else could publish "updates". Keep it out of the
repository and back it up somewhere safe (e.g. a password manager that holds
files, plus an offline copy).

In PowerShell (keytool comes with the JDK):

```powershell
mkdir $env:USERPROFILE\keys
keytool -genkeypair -v -keystore "$env:USERPROFILE\keys\santaroni-release.jks" `
  -storetype PKCS12 -keyalg RSA -keysize 4096 -validity 36500 -alias santaroni
```

It asks for a password (with PKCS12, the key uses the same one) and for name
details, which end up in the certificate anyone can read from the APK: put
`Lux Aeterna Soft` as the organization, or leave fields blank.

### 2. Give the key to GitHub Actions

In the repository on GitHub: **Settings › Secrets and variables › Actions ›
New repository secret**, four times:

| Secret | Value |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | The keystore file as text (see below) |
| `ANDROID_KEYSTORE_PASSWORD` | The password you chose |
| `ANDROID_KEY_ALIAS` | `santaroni` |
| `ANDROID_KEY_PASSWORD` | The same password |

To copy the keystore as text to the clipboard (PowerShell):

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("$env:USERPROFILE\keys\santaroni-release.jks")) | Set-Clipboard
```

Secrets can't be read back from GitHub, only replaced, and they aren't
available to workflows started from forks.

### 3. (Optional) Signed builds on your PC

Create `android/key.properties` (git-ignored). Use forward slashes in the
path:

```properties
storeFile=C:/Users/<you>/keys/santaroni-release.jks
storePassword=<password>
keyAlias=santaroni
keyPassword=<password>
```

Without this file, `flutter build apk --release` still works but signs with
the debug key, which is fine for testing and must never be published.

## Each release

1. Update `version:` in `pubspec.yaml`, e.g. `1.0.1+2`. The part before `+`
   is the version people see; the number after it is Android's version code,
   which **must go up by at least one every release** (Android refuses to
   "update" to a lower or equal one).
2. Commit, then tag that commit with the same version and push both:

   ```sh
   git tag v1.0.1
   git push origin main v1.0.1
   ```

   The workflow stops if the tag doesn't match `pubspec.yaml`.
3. Watch it in the **Actions** tab (usually 10–20 minutes). When it's done, open
   **Releases**, check the draft (edit the notes if you like) and press
   **Publish release**.

If a build fails, fix it, then move the tag to the new commit:
`git tag -f v1.0.1` and `git push -f origin v1.0.1`. Delete the old draft
release first so the files don't mix.

## Building locally

- **Windows:** install [Inno Setup 6](https://jrsoftware.org/isdl.php), then
  run `pwsh installer\build-windows.ps1` (or `powershell -File …`). The
  installer and zip land in `dist\`.
- **Android:** `flutter build apk --release`, optionally
  `--target-platform android-arm64` for the smaller phone-only APK. Output:
  `build\app\outputs\flutter-apk\app-release.apk`.

## Notes

- **Windows SmartScreen:** the installer isn't code-signed (certificates
  cost money and need identity checks), so the first people to download a
  new version see "Windows protected your PC". They can choose
  **More info › Run anyway**. Free signing for open-source projects is
  available from SignPath Foundation if this becomes a problem.
- **Data survives updates:** events and settings live in
  `%APPDATA%\Lux Aeterna Soft\Santaroni` on Windows (kept even after
  uninstalling) and in the app's private storage on Android (removed when
  the app is uninstalled), never in the install folder. The email password
  is in the system's credential store.
- **Flutter version:** the workflows pin the same Flutter version as
  development (`FLUTTER_VERSION`); update it there when upgrading Flutter.
