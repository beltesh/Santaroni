import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:santaroni/data/legacy_data_migration.dart';

void main() {
  late Directory root;
  late Directory oldDir;
  late Directory newDir;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('santaroni_move');
    oldDir = Directory(p.join(root.path, 'Santaroni', 'Santaroni'));
    newDir = Directory(p.join(root.path, 'Lux Aeterna Soft', 'Santaroni'));
  });
  tearDown(() => root.delete(recursive: true));

  Future<void> write(Directory dir, String name, String content) async {
    await dir.create(recursive: true);
    await File(p.join(dir.path, name)).writeAsString(content);
  }

  test('moves the database and password store, then removes the old folders', () async {
    await write(oldDir, 'santaroni.sqlite', 'db');
    await write(oldDir, 'flutter_secure_storage.dat', 'secret');

    expect(await moveLegacyData(from: oldDir, to: newDir), isTrue);

    expect(File(p.join(newDir.path, 'santaroni.sqlite')).readAsStringSync(), 'db');
    expect(File(p.join(newDir.path, 'flutter_secure_storage.dat')).readAsStringSync(), 'secret');
    expect(oldDir.existsSync(), isFalse);
    expect(oldDir.parent.existsSync(), isFalse);
  });

  test('never overwrites data already in the new folder', () async {
    await write(oldDir, 'santaroni.sqlite', 'old');
    await write(newDir, 'santaroni.sqlite', 'new');

    expect(await moveLegacyData(from: oldDir, to: newDir), isFalse);

    expect(File(p.join(newDir.path, 'santaroni.sqlite')).readAsStringSync(), 'new');
    expect(File(p.join(oldDir.path, 'santaroni.sqlite')).existsSync(), isTrue);
  });

  test('does nothing when there is no old folder', () async {
    expect(await moveLegacyData(from: oldDir, to: newDir), isFalse);
    expect(newDir.existsSync(), isFalse);
  });

  test('keeps the old parent folder if something else lives there', () async {
    await write(oldDir, 'santaroni.sqlite', 'db');
    await write(oldDir.parent, 'other.txt', 'unrelated');

    await moveLegacyData(from: oldDir, to: newDir);

    expect(oldDir.existsSync(), isFalse);
    expect(File(p.join(oldDir.parent.path, 'other.txt')).existsSync(), isTrue);
  });
}
