# App icon

| File | Used for |
|---|---|
| `santaroni-full.png` | Windows icon and Android 7 (flat) icon. 1024×1024. |
| `santaroni-foreground.png` | Android adaptive icon foreground. 1024×1024, transparent, artwork kept inside the center ~60% (Android's safe zone). |
| `santaroni-monochrome.png` | Android 13+ themed icon. Same size and safe zone; only the alpha channel is used. |
| `originals/` | The designer's source files (JPEGs). |

The Android background color is `#7F030E` (set in `flutter_launcher_icons.yaml`).

## Regenerating

After changing any of the images, from the project root:

```sh
dart run flutter_launcher_icons        # Android: all densities + adaptive + monochrome
dart run tool/make_windows_icon.dart   # Windows: multi-size app_icon.ico
```

Then rebuild the app (a hot reload won't pick up icon changes).
