import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_local_settings_repository.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';

import '../contracts/local_settings_contract.dart';
import '../contracts/transaction_runner_contract.dart';

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());
  group('Drift LocalSettings contract', () {
    runLocalSettingsRepositoryContract(() => DriftLocalSettingsRepository(db));
  });
  group('Drift TransactionRunner contract', () {
    runTransactionRunnerContract(() {
      final settings = DriftLocalSettingsRepository(db);
      return (
        runner: DriftTransactionRunner(db),
        write: (int a, int b) async {
          await settings.setInt('a', a);
          await settings.setInt('b', b);
        },
        read: () async => [await settings.getInt('a') ?? 0, await settings.getInt('b') ?? 0],
      );
    });
  });
}
