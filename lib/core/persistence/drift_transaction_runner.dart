import 'dart:async';

import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/services/in_memory_transaction_runner.dart';
import 'package:laurum/core/services/transaction_runner.dart';

class DriftTransactionRunner implements TransactionRunner {
  DriftTransactionRunner(this.db, {Iterable<TransactionParticipant> Function()? participants})
    : _memory = InMemoryTransactionRunner(participants ?? () => const []);
  final AppDatabase db;
  final InMemoryTransactionRunner _memory;
  final Object _zoneKey = Object();

  @override
  Future<T> run<T>(Future<T> Function() body) async {
    final active = Zone.current[_zoneKey];
    if (active is _DriftScope && active.open) {
      try {
        return await db.transaction(body, requireNew: true);
      } catch (error, stack) {
        active.error ??= error;
        active.stack ??= stack;
        rethrow;
      }
    }
    return _memory.run(() async {
      final scope = _DriftScope();
      try {
        return await db.transaction(
          () => runZoned(() async {
            final result = await body();
            if (scope.error != null) Error.throwWithStackTrace(scope.error!, scope.stack!);
            return result;
          }, zoneValues: {_zoneKey: scope}),
        );
      } catch (_) {
        for (final undo in scope.rollback) {
          try {
            await undo();
          } catch (_) {
            // File cleanup is best effort; preserve the original transaction failure.
          }
        }
        rethrow;
      } finally {
        scope.open = false;
      }
    });
  }

  void onRollback(Future<void> Function() undo) {
    final scope = Zone.current[_zoneKey];
    if (scope is! _DriftScope || !scope.open) throw StateError('No active transaction');
    scope.rollback.add(undo);
  }
}

class _DriftScope {
  final rollback = <Future<void> Function()>[];
  bool open = true;
  Object? error;
  StackTrace? stack;
}
