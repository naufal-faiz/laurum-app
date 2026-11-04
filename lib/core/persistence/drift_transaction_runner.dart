import 'dart:async';

import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/services/transaction_runner.dart';

class DriftTransactionRunner implements TransactionRunner {
  DriftTransactionRunner(this.db);
  final AppDatabase db;
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
    final scope = _DriftScope();
    try {
      return await db.transaction(
        () => runZoned(() async {
          final result = await body();
          if (scope.error != null) Error.throwWithStackTrace(scope.error!, scope.stack!);
          return result;
        }, zoneValues: {_zoneKey: scope}),
      );
    } finally {
      scope.open = false;
    }
  }
}

class _DriftScope {
  bool open = true;
  Object? error;
  StackTrace? stack;
}
