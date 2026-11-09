import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_local_settings_repository.dart';
import 'package:laurum/core/persistence/drift_sync_service.dart';
import 'package:laurum/core/persistence/sync_last_at_store.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/core/sync/sync_coordinator.dart';
import 'package:laurum/core/sync/sync_pull_result.dart';
import 'package:laurum/core/sync/sync_run_result.dart';

class _Cycle implements SyncCycle {
  _Cycle({this.succeeds = true, this.onRun});
  final bool succeeds;
  final Future<void> Function()? onRun;
  int runs = 0;

  @override
  Future<SyncCycleResult> run() async {
    runs++;
    await onRun?.call();
    final status = succeeds ? SyncRunStatus.selesai : SyncRunStatus.gagal;
    return SyncCycleResult(
      push: SyncRunResult(status: status, committedGroups: 0, pendingChanges: 0),
      pull: SyncPullResult(
        status: succeeds ? SyncPullStatus.selesai : SyncPullStatus.gagal,
        tablesPulled: 0,
        appliedRows: 0,
      ),
    );
  }
}

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> addOutbox(String id) => db
      .into(db.outboxRecords)
      .insert(
        OutboxRecordsCompanion.insert(
          id: id,
          targetTable: 'orders',
          rowId: id,
          op: 'upsert',
          payload: '{}',
          createdAt: DateTime.utc(2026, 11, 9),
        ),
      );

  test('without a cycle it only refreshes the pending count', () async {
    await addOutbox('a');
    final sync = DriftSyncService(db);
    addTearDown(sync.dispose);
    await sync.start();
    expect(sync.canSync, isFalse);
    expect(sync.pendingChanges, 1);
    expect(sync.currentStatus, SyncServiceStatus.menyimpan);
    await sync.syncNow();
    expect(sync.pendingChanges, 1);
    expect(sync.lastSyncedAt, isNull);
  });

  test('a successful cycle stores the clock time and drains the outbox', () async {
    final at = DateTime.utc(2026, 11, 9, 10, 30);
    final cycle = _Cycle(onRun: () => db.delete(db.outboxRecords).go());
    final sync = DriftSyncService(db, cycle: cycle, clock: () => at);
    addTearDown(sync.dispose);
    await sync.start();
    await addOutbox('a');
    await sync.syncNow();
    expect(cycle.runs, 1);
    expect(sync.pendingChanges, 0);
    expect(sync.currentStatus, SyncServiceStatus.tersimpan);
    expect(sync.lastSyncedAt, at);
    final stored = await DriftLocalSettingsRepository(db).getString(syncLastAtKey);
    expect(stored, at.toIso8601String());
  });

  test('a failed cycle reports gagal and rethrows', () async {
    final sync = DriftSyncService(db, cycle: _Cycle(succeeds: false));
    addTearDown(sync.dispose);
    await sync.start();
    await expectLater(sync.syncNow(), throwsStateError);
    expect(sync.currentStatus, SyncServiceStatus.gagal);
    expect(sync.lastSyncedAt, isNull);
  });

  test('lastSyncedAt survives a restart', () async {
    final at = DateTime.utc(2026, 11, 9, 11);
    final first = DriftSyncService(db, cycle: _Cycle(), clock: () => at);
    await first.start();
    await first.syncNow();
    await first.dispose();
    final second = DriftSyncService(db);
    addTearDown(second.dispose);
    await second.start();
    expect(second.lastSyncedAt, at);
  });

  test('offline rejects manual sync and recovery runs the cycle', () async {
    final cycle = _Cycle();
    final sync = DriftSyncService(db, cycle: cycle);
    addTearDown(sync.dispose);
    await sync.start();
    sync.setConnection(online: false);
    expect(sync.currentStatus, SyncServiceStatus.offline);
    expect(sync.canSync, isFalse);
    await expectLater(sync.syncNow(), throwsStateError);
    sync.setConnection(online: true);
    await pumpEventQueue();
    expect(sync.currentStatus, SyncServiceStatus.tersimpan);
    expect(cycle.runs, 1);
  });

  test('foreground runs a cycle when the gate is open', () async {
    final cycle = _Cycle();
    final sync = DriftSyncService(db, cycle: cycle);
    addTearDown(sync.dispose);
    await sync.start();
    sync.notifyForeground();
    await pumpEventQueue();
    expect(cycle.runs, 1);
  });
}
