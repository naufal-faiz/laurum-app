import 'dart:async';

import 'package:laurum/core/services/transaction_runner.dart';

class InMemoryTransactionRunner implements TransactionRunner {
  InMemoryTransactionRunner(this.participants);
  final Iterable<TransactionParticipant> Function() participants;
  final Object _zoneKey = Object();
  Future<void> _tail = Future.value();

  @override
  Future<T> run<T>(Future<T> Function() body) async {
    final active = Zone.current[_zoneKey];
    if (active is _TransactionScope && active.open) {
      try {
        return await body();
      } catch (error, stack) {
        active.error ??= error;
        active.stack ??= stack;
        rethrow;
      }
    }
    final previous = _tail;
    final done = Completer<void>();
    _tail = done.future;
    await previous;
    final scope = _TransactionScope();
    final restore = <void Function()>[];
    try {
      // Initialize every participant before capturing any snapshot.
      final stores = participants().toSet().toList();
      for (final store in stores) {
        restore.add(store.checkpoint());
      }
      final result = await runZoned(body, zoneValues: {_zoneKey: scope});
      if (scope.error != null) Error.throwWithStackTrace(scope.error!, scope.stack!);
      return result;
    } catch (_) {
      // Sync is registered last so repository notifications are restored first.
      for (final rollback in restore) {
        rollback();
      }
      rethrow;
    } finally {
      scope.open = false;
      done.complete();
    }
  }
}

class _TransactionScope {
  bool open = true;
  Object? error;
  StackTrace? stack;
}
