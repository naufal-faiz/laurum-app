import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/account_store.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_sync_remote_applier.dart';
import 'package:laurum/core/sync/sync_coordinator.dart';
import 'package:laurum/core/sync/sync_pull_result.dart';
import 'package:laurum/core/sync/sync_run_result.dart';

import '../persistence/sync_wire_rows.dart';

class RestoringCycle implements SyncCycle {
  RestoringCycle(this.db, {this.fail = false});
  final AppDatabase db;
  final bool fail;
  int runs = 0;
  @override
  Future<SyncCycleResult> run() async {
    runs++;
    if (fail) throw StateError('Network unavailable');
    final applier = DriftSyncRemoteApplier(db, wireOwner);
    await applier.apply('businesses', [allWireRows().first]);
    await applier.apply('customers', [customerRow()]);
    return const SyncCycleResult(
      push: SyncRunResult(status: SyncRunStatus.selesai, committedGroups: 0, pendingChanges: 0),
      pull: SyncPullResult(status: SyncPullStatus.selesai, tablesPulled: 2, appliedRows: 2),
    );
  }
}

void main() {
  for (final fail in [false, true]) {
    test('opening an account fetches cloud data and survives network failure=$fail', () async {
      final db = AppDatabase(NativeDatabase.memory());
      final cycle = RestoringCycle(db, fail: fail);
      final store = AccountStore(
        db,
        wireOwner,
        directory: () async => Directory.systemTemp,
        cycle: cycle,
      );
      addTearDown(() async {
        await store.dispose();
        await db.close();
      });
      await store.start();
      expect(cycle.runs, 1);
      expect((await store.business.getProfile()).name, fail ? '' : 'Laundry Sari');
      expect(await store.customers.getCustomers(), hasLength(fail ? 0 : 1));
      expect(store.sync.canSync, isTrue);
    });
  }
}
