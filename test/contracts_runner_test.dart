import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/in_memory_local_settings_repository.dart';
import 'package:laurum/core/services/in_memory_transaction_runner.dart';

import 'contracts/transaction_runner_contract.dart';

void main() {
  group('InMemory runner contract', () {
    runTransactionRunnerContract(() {
      final a = InMemoryLocalSettingsRepository(), b = InMemoryLocalSettingsRepository();
      return (
        runner: InMemoryTransactionRunner(() => [a, b]),
        write: (int x, int y) async {
          await a.setInt('v', x);
          await b.setInt('v', y);
        },
        read: () async => [await a.getInt('v') ?? 0, await b.getInt('v') ?? 0],
      );
    });
  });
}
