import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/in_memory_transaction_runner.dart';
import 'package:laurum/core/services/transaction_runner.dart';

class TransactionValue implements TransactionParticipant {
  int value = 0;
  @override
  void Function() checkpoint() {
    final saved = value;
    return () => value = saved;
  }
}

void main() {
  late TransactionValue first, second;
  late TransactionRunner runner;
  setUp(() {
    first = TransactionValue();
    second = TransactionValue();
    runner = InMemoryTransactionRunner(() => [first, second]);
  });
  test('success commits all participants and returns body result', () async {
    expect(
      await runner.run(() async {
        first.value = 1;
        second.value = 2;
        return 'saved';
      }),
      'saved',
    );
    expect([first.value, second.value], [1, 2]);
  });
  test('second write failure restores first and rethrows same error', () async {
    final error = StateError('second write');
    await expectLater(
      runner.run(() async {
        first.value = 1;
        second.value = 2;
        throw error;
      }),
      throwsA(same(error)),
    );
    expect([first.value, second.value], [0, 0]);
  });
  test('nested success joins outer rollback', () async {
    await expectLater(
      runner.run(() async {
        first.value = 1;
        await runner.run(() async => second.value = 2);
        throw StateError('outer');
      }),
      throwsStateError,
    );
    expect([first.value, second.value], [0, 0]);
  });
  test('caught nested failure still aborts the whole transaction', () async {
    await expectLater(
      runner.run(() async {
        first.value = 1;
        try {
          await runner.run<void>(() async => throw StateError('inner'));
        } on StateError {
          second.value = 2;
        }
      }),
      throwsStateError,
    );
    expect([first.value, second.value], [0, 0]);
  });
  test('independent transactions serialize instead of sharing a snapshot', () async {
    final entered = Completer<void>(), release = Completer<void>();
    final failed = runner.run(() async {
      first.value = 1;
      entered.complete();
      await release.future;
      throw StateError('rollback');
    });
    final checked = expectLater(failed, throwsStateError);
    await entered.future;
    final next = runner.run(() async {
      expect(first.value, 0);
      second.value = 3;
    });
    release.complete();
    await checked;
    await next;
    expect([first.value, second.value], [0, 3]);
  });
}
