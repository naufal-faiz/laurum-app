import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/sync/sync_scheduler.dart';
import 'package:laurum/core/sync/sync_timing.dart';

void main() {
  test('retry delay doubles and stops at fifteen minutes', () {
    expect(syncRetryDelay(1), const Duration(seconds: 2));
    expect(syncRetryDelay(2), const Duration(seconds: 4));
    expect(syncRetryDelay(3), const Duration(seconds: 8));
    expect(syncRetryDelay(9), const Duration(seconds: 512));
    expect(syncRetryDelay(10), syncRetryMax);
    expect(syncRetryDelay(99), syncRetryMax);
  });

  test('local changes debounce into one run two seconds after the last write', () {
    fakeAsync((async) {
      var runs = 0;
      final scheduler = SyncScheduler(run: () async => runs++);
      scheduler.localChange();
      async.elapse(const Duration(seconds: 1));
      scheduler.localChange();
      async.elapse(const Duration(milliseconds: 1999));
      async.flushMicrotasks();
      expect(runs, 0);
      async.elapse(const Duration(milliseconds: 1));
      async.flushMicrotasks();
      expect(runs, 1);
      scheduler.dispose();
    });
  });

  test('immediate triggers cancel the debounce and run once', () {
    fakeAsync((async) {
      var runs = 0;
      final scheduler = SyncScheduler(run: () async => runs++);
      scheduler.localChange();
      scheduler.immediate();
      async.flushMicrotasks();
      async.elapse(const Duration(seconds: 3));
      async.flushMicrotasks();
      expect(runs, 1);
      scheduler.dispose();
    });
  });

  test('a request during a run waits and runs once afterwards', () {
    fakeAsync((async) {
      final gates = <Completer<void>>[];
      final scheduler = SyncScheduler(
        run: () {
          final gate = Completer<void>();
          gates.add(gate);
          return gate.future;
        },
      );
      scheduler.immediate();
      async.flushMicrotasks();
      expect(gates, hasLength(1));
      scheduler.immediate();
      scheduler.localChange();
      async.flushMicrotasks();
      expect(gates, hasLength(1));
      gates.first.complete();
      async.flushMicrotasks();
      async.elapse(syncDebounce);
      async.flushMicrotasks();
      expect(gates, hasLength(2));
      gates.last.complete();
      async.flushMicrotasks();
      scheduler.dispose();
    });
  });

  test('failures retry with backoff and success starts over', () {
    fakeAsync((async) {
      var calls = 0;
      final scheduler = SyncScheduler(
        run: () async {
          calls++;
          if (calls < 3) throw StateError('boom');
        },
      );
      scheduler.immediate();
      async.flushMicrotasks();
      expect(calls, 1);
      async.elapse(const Duration(seconds: 2));
      async.flushMicrotasks();
      expect(calls, 2);
      async.elapse(const Duration(seconds: 4));
      async.flushMicrotasks();
      expect(calls, 3);
      async.elapse(syncRetryMax);
      async.flushMicrotasks();
      expect(calls, 3);
      scheduler.dispose();
    });
  });

  test('offline cancels work and recovery runs again', () {
    fakeAsync((async) {
      var runs = 0;
      final scheduler = SyncScheduler(run: () async => runs++);
      scheduler.setOnline(online: false);
      scheduler.localChange();
      scheduler.immediate();
      async.elapse(const Duration(seconds: 5));
      async.flushMicrotasks();
      expect(runs, 0);
      scheduler.setOnline(online: true);
      async.flushMicrotasks();
      expect(runs, 1);
      scheduler.dispose();
    });
  });

  test('periodic trigger fires only while enabled', () {
    fakeAsync((async) {
      var runs = 0;
      final scheduler = SyncScheduler(run: () async => runs++);
      scheduler.startPeriodic();
      async.elapse(syncPeriodic);
      async.flushMicrotasks();
      expect(runs, 1);
      async.elapse(syncPeriodic);
      async.flushMicrotasks();
      expect(runs, 2);
      scheduler.dispose();
      async.elapse(syncPeriodic);
      async.flushMicrotasks();
      expect(runs, 2);
    });
  });
}
