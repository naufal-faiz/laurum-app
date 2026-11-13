import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/sync/sync_scheduler.dart';

void main() {
  test('manual sync waits for an automatic run and drains a following cycle', () async {
    final gate = Completer<void>();
    var runs = 0, finished = false;
    final scheduler = SyncScheduler(
      run: () async {
        if (++runs == 1) await gate.future;
      },
    );
    addTearDown(scheduler.dispose);
    scheduler.immediate();
    await Future<void>.delayed(Duration.zero);
    final manual = scheduler.triggerNow().then((_) => finished = true);
    await Future<void>.delayed(Duration.zero);
    expect(finished, isFalse);
    gate.complete();
    await manual;
    expect(runs, 2);
    expect(finished, isTrue);
  });
}
