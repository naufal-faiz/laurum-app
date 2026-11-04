import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_local_settings_repository.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';

void main() {
  late AppDatabase db;
  late DriftTransactionRunner runner;
  late DriftLocalSettingsRepository settings;
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    runner = DriftTransactionRunner(db);
    settings = DriftLocalSettingsRepository(db);
  });
  tearDown(() => db.close());
  test('independent transactions serialize and do not share an aborted snapshot', () async {
    final entered = Completer<void>(), release = Completer<void>();
    final failed = runner.run(() async {
      await settings.setInt('value', 1);
      entered.complete();
      await release.future;
      throw StateError('rollback');
    });
    final checked = expectLater(failed, throwsStateError);
    await entered.future;
    final next = runner.run(() async {
      expect(await settings.getInt('value'), isNull);
      await settings.setInt('value', 3);
    });
    release.complete();
    await checked;
    await next;
    expect(await settings.getInt('value'), 3);
  });
  test('native savepoint rolls back inner writes before outer transaction aborts', () async {
    await expectLater(
      runner.run(() async {
        await settings.setInt('value', 1);
        try {
          await runner.run<void>(() async {
            await settings.setInt('value', 2);
            throw StateError('inner');
          });
        } on StateError {
          expect(await settings.getInt('value'), 1);
        }
      }),
      throwsStateError,
    );
    expect(await settings.getInt('value'), isNull);
  });
}
