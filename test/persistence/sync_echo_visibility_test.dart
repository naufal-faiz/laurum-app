import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_change_monitor.dart';
import 'package:laurum/core/persistence/drift_sync_remote_applier.dart';
import 'package:laurum/core/sync/sync_table_names.dart';

import 'sync_wire_rows.dart';

void main() {
  late AppDatabase db;
  late DriftChangeMonitor monitor;
  late DriftSyncRemoteApplier applier;
  late StreamSubscription<int> subscription;
  final revisions = <int>[];
  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    monitor = DriftChangeMonitor(db)..start();
    subscription = monitor.stream.listen(revisions.add);
    applier = DriftSyncRemoteApplier(db, wireOwner);
    final rows = allWireRows();
    for (var i = 0; i < syncPullOrder.length; i++) {
      await applier.apply(syncPullOrder[i], [rows[i]]);
    }
    await pumpEventQueue();
    revisions.clear();
  });
  tearDown(() async {
    await subscription.cancel();
    await monitor.dispose();
    await db.close();
  });
  for (final table in ['customers', 'orders']) {
    test('$table push echo persists sync metadata without invalidating business screens', () async {
      final row = allWireRows()[syncPullOrder.indexOf(table)];
      await db.customStatement('UPDATE "$table" SET sync_state = ?', ['pending']);
      const updated = '2026-11-16T10:00:00.000000Z';
      await applier.apply(table, [
        {...row, 'updated_at': updated},
      ]);
      await pumpEventQueue();
      expect(revisions, isEmpty);
      final stored = await db.customSelect('SELECT * FROM "$table"').getSingle();
      expect(stored.read<String>('sync_state'), 'synced');
      expect(stored.read<String>('updated_at'), updated);
    });
  }
  test('identical full pull does not invalidate already mounted business queries', () async {
    final rows = allWireRows();
    for (var i = 0; i < syncPullOrder.length; i++) {
      await applier.apply(syncPullOrder[i], [rows[i]]);
    }
    await pumpEventQueue();
    expect(revisions, isEmpty);
  });
  test('actual remote customer, expense and deletion changes still notify queries', () async {
    await applier.apply('customers', [customerRow(name: 'Nama baru')]);
    await pumpEventQueue();
    expect(revisions, isNotEmpty);
    expect((await db.select(db.customerRecords).getSingle()).name, 'Nama baru');
    revisions.clear();
    final expense = allWireRows().firstWhere((row) => row['id'] == wireExpense);
    await applier.apply('expenses', [
      {...expense, 'amount': 25000},
    ]);
    await pumpEventQueue();
    expect(revisions, isNotEmpty);
    expect((await db.select(db.expenseRecords).getSingle()).amount, 25000);
    revisions.clear();
    await applier.apply('customers', [
      {...customerRow(), 'deleted_at': wireAt},
    ]);
    await pumpEventQueue();
    expect(revisions, isNotEmpty);
    expect((await db.select(db.customerRecords).getSingle()).deletedAt, isNotNull);
  });
}
