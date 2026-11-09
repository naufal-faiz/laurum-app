import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/account_store.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/sync/sync_coordinator.dart';
import 'package:laurum/core/sync/sync_pull_result.dart';
import 'package:laurum/core/sync/sync_run_result.dart';

class _Cycle implements SyncCycle {
  int runs = 0;

  @override
  Future<SyncCycleResult> run() async {
    runs++;
    return const SyncCycleResult(
      push: SyncRunResult(status: SyncRunStatus.selesai, committedGroups: 0, pendingChanges: 0),
      pull: SyncPullResult(status: SyncPullStatus.selesai, tablesPulled: 0, appliedRows: 0),
    );
  }
}

AccountStore _store(AppDatabase db, {SyncCycle? cycle}) => AccountStore(
  db,
  'owner-1',
  directory: () async => Directory.systemTemp,
  cycle: cycle,
);

void main() {
  test('a cycle factory opens the B2d gate and runs push-then-pull', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final cycle = _Cycle();
    final store = _store(db, cycle: cycle);
    addTearDown(() async {
      await store.dispose();
      await db.close();
    });
    await store.start();
    expect(store.sync.canSync, isTrue);
    expect(
      await db.select(db.deviceRecords).get(),
      hasLength(1),
      reason: 'the install registers itself once real sync exists',
    );
    await store.sync.syncNow();
    expect(cycle.runs, 1);
    expect(store.sync.lastSyncedAt, isNotNull);
  });

  test('without a cycle the gate stays closed and no network call happens', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final store = _store(db);
    addTearDown(() async {
      await store.dispose();
      await db.close();
    });
    await store.start();
    expect(store.sync.canSync, isFalse);
    expect(await db.select(db.deviceRecords).get(), isEmpty);
    await store.sync.syncNow();
    expect(store.sync.lastSyncedAt, isNull);
  });
}
