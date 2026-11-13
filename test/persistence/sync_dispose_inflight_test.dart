import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_sync_service.dart';
import 'package:laurum/core/sync/sync_coordinator.dart';
import 'package:laurum/core/sync/sync_pull_result.dart';
import 'package:laurum/core/sync/sync_run_result.dart';

class PendingSyncCycle implements SyncCycle {
  final gate = Completer<void>();
  @override
  Future<SyncCycleResult> run() async {
    await gate.future;
    return const SyncCycleResult(
      push: SyncRunResult(status: SyncRunStatus.selesai, committedGroups: 0, pendingChanges: 0),
      pull: SyncPullResult(status: SyncPullStatus.selesai, tablesPulled: 0, appliedRows: 0),
    );
  }
}

void main() {
  test('storage disposal waits for in-flight SQLite work before closing the database', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final cycle = PendingSyncCycle();
    final sync = DriftSyncService(db, cycle: cycle);
    await sync.start();
    final running = sync.syncNow();
    var closed = false;
    final closing = sync.dispose().then((_) => closed = true);
    await Future<void>.delayed(Duration.zero);
    expect(closed, isFalse);
    cycle.gate.complete();
    await running;
    await closing;
    expect(closed, isTrue);
    expect(await db.customSelect('SELECT 1').get(), hasLength(1));
  });
}
