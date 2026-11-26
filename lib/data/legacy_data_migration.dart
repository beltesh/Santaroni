import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// On Windows, app data lives in %APPDATA%\<company>\<product>, so changing
/// the company name (to "Lux Aeterna Soft") moved the folder. This brings the
/// database and the encrypted password store along from the old folder.
///
/// Must run before the database is opened. Does nothing on other platforms
/// (Android data is tied to the app ID, not the company name).
Future<void> migrateLegacyDataDirectory() async {
  if (!Platform.isWindows) return;
  try {
    final current = await getApplicationSupportDirectory();
    final appData = current.parent.parent; // %APPDATA%
    await moveLegacyData(
      from: Directory(p.join(appData.path, 'Santaroni', 'Santaroni')),
      to: current,
    );
  } catch (_) {
    // Never block startup over this; worst case the app starts fresh.
  }
}

const _databaseFile = 'santaroni.sqlite';

/// Moves every file from [from] into [to], unless [to] already has a
/// database (never overwrite newer data). Removes the old folders once
/// empty. Returns whether anything was moved.
Future<bool> moveLegacyData({
  required Directory from,
  required Directory to,
}) async {
  if (p.equals(from.path, to.path) || !from.existsSync()) return false;
  if (File(p.join(to.path, _databaseFile)).existsSync()) return false;

  await to.create(recursive: true);
  var moved = false;
  for (final entity in from.listSync()) {
    if (entity is! File) continue;
    final target = p.join(to.path, p.basename(entity.path));
    try {
      await entity.rename(target);
    } on FileSystemException {
      // Different drive or locked rename: copy, then remove the original.
      await entity.copy(target);
      await entity.delete();
    }
    moved = true;
  }

  // Clean up the old folders, but only if they're now empty.
  for (final dir in [from, from.parent]) {
    try {
      await dir.delete();
    } on FileSystemException {
      break;
    }
  }
  return moved;
}
