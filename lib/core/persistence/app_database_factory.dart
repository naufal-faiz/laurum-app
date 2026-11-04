import 'dart:io';

import 'package:drift/native.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:path_provider/path_provider.dart';

class AppDatabaseFactory {
  AppDatabaseFactory(this.ownerId, {Future<Directory> Function()? directory})
    : _directory = directory ?? getApplicationSupportDirectory {
    if (!RegExp(r'^[a-zA-Z0-9_-]{1,128}$').hasMatch(ownerId)) {
      throw ArgumentError('Invalid account identifier');
    }
  }
  final String ownerId;
  final Future<Directory> Function() _directory;
  AppDatabase? _database;
  Future<void> _tail = Future.value();

  Future<T> _serial<T>(Future<T> Function() body) {
    final result = _tail.then((_) => body());
    _tail = result.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return result;
  }

  Future<File> databaseFile() async {
    if (!(Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isWindows ||
        Platform.isLinux ||
        Platform.isMacOS)) {
      throw UnsupportedError('Native SQLite required');
    }
    final directory = await _directory();
    await directory.create(recursive: true);
    return File('${directory.path}${Platform.pathSeparator}laurum_$ownerId.db');
  }

  Future<AppDatabase> open() => _serial(() async {
    return _database ??= AppDatabase(NativeDatabase.createInBackground(await databaseFile()));
  });

  Future<void> _close() async {
    final current = _database;
    _database = null;
    await current?.close();
  }

  Future<void> close() => _serial(_close);

  // Callers must release repositories before deleting their account database.
  Future<void> delete() => _serial(() async {
    await _close();
    final file = await databaseFile();
    for (final suffix in ['', '-wal', '-shm', '-journal']) {
      final target = File('${file.path}$suffix');
      if (await target.exists()) await target.delete();
    }
  });
}
