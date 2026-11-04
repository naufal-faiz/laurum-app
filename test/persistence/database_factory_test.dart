import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database_factory.dart';
import 'package:laurum/core/persistence/drift_local_settings_repository.dart';

void main() {
  // These tests intentionally open separate files for separate accounts.
  final oldWarningSetting = driftRuntimeOptions.dontWarnAboutMultipleDatabases;
  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);
  tearDownAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = oldWarningSetting);
  late Directory directory;
  late AppDatabaseFactory first, second;
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('laurum-b1a-');
    first = AppDatabaseFactory('owner-a', directory: () async => directory);
    second = AppDatabaseFactory('owner-b', directory: () async => directory);
  });
  tearDown(() async {
    await first.close();
    await second.close();
    await directory.delete(recursive: true);
  });
  test('account files isolate data and persist across reopening', () async {
    final a = await first.open(), b = await second.open();
    expect(await first.open(), same(a));
    await DriftLocalSettingsRepository(a).setInt('counter', 143);
    await DriftLocalSettingsRepository(b).setInt('counter', 7);
    expect((await first.databaseFile()).path, endsWith('laurum_owner-a.db'));
    await first.close();
    final reopened = await first.open();
    expect(await DriftLocalSettingsRepository(reopened).getInt('counter'), 143);
    expect(await DriftLocalSettingsRepository(b).getInt('counter'), 7);
  });
  test('delete closes own database and leaves other account untouched', () async {
    await DriftLocalSettingsRepository(await first.open()).setString('printer', '58mm');
    await DriftLocalSettingsRepository(await second.open()).setInt('counter', 7);
    final file = await first.databaseFile();
    await first.delete();
    expect(await file.exists(), isFalse);
    expect(await (await second.databaseFile()).exists(), isTrue);
    expect(await DriftLocalSettingsRepository(await second.open()).getInt('counter'), 7);
    expect(await DriftLocalSettingsRepository(await first.open()).getString('printer'), isNull);
  });
  test('unsafe account identifiers reject before constructing a path', () {
    for (final id in ['', '../other', r'..\other', 'owner/a', 'owner:b', '.']) {
      expect(() => AppDatabaseFactory(id), throwsArgumentError);
    }
  });
}
