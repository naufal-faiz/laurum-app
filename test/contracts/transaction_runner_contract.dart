import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/transaction_runner.dart';

import 'repository_factory.dart';

typedef RunnerHarness = ({
  TransactionRunner runner,
  Future<void> Function(int, int) write,
  Future<List<int>> Function() read,
});

void runTransactionRunnerContract(RepositoryFactory<RunnerHarness> factory) {
  late RunnerHarness h;
  setUp(() async => h = await factory());
  test('commit across participants and return value', () async {
    expect(
      await h.runner.run(() async {
        await h.write(1, 2);
        return 'saved';
      }),
      'saved',
    );
    expect(await h.read(), [1, 2]);
  });
  test('rollback all writes and rethrow original error', () async {
    final error = StateError('write failed');
    await expectLater(
      h.runner.run(() async {
        await h.write(1, 2);
        throw error;
      }),
      throwsA(same(error)),
    );
    expect(await h.read(), [0, 0]);
  });
  test('nested success rolls back with outer failure', () async {
    await expectLater(
      h.runner.run(() async {
        await h.runner.run(() => h.write(1, 2));
        throw StateError('outer');
      }),
      throwsStateError,
    );
    expect(await h.read(), [0, 0]);
  });
  test('caught nested failure aborts outer transaction', () async {
    await expectLater(
      h.runner.run(() async {
        await h.write(1, 2);
        try {
          await h.runner.run<void>(() async => throw StateError('inner'));
        } on StateError {
          await h.write(3, 4);
        }
      }),
      throwsStateError,
    );
    expect(await h.read(), [0, 0]);
  });
}
