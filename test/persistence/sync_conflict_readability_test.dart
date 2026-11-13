import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/account_store.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_sync_remote_applier.dart';
import 'package:laurum/core/sync/sync_table_names.dart';

import 'sync_wire_rows.dart';

void main() {
  test('rejected sync metadata never makes local business data unreadable', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final store = AccountStore(db, wireOwner, directory: () async => Directory.systemTemp);
    addTearDown(() async {
      await store.dispose();
      await db.close();
    });
    final rows = allWireRows();
    final applier = DriftSyncRemoteApplier(db, wireOwner);
    for (var index = 0; index < syncPullOrder.length; index++) {
      final table = syncPullOrder[index];
      await applier.apply(table, [rows[index]]);
      await db.customStatement('UPDATE "$table" SET sync_state = ?', ['conflict']);
    }
    expect((await store.business.getProfile()).syncState.name, 'conflict');
    expect((await store.business.getReceiptSettings()).syncState.name, 'conflict');
    expect((await store.customers.getCustomers()).single.syncState.name, 'conflict');
    expect((await store.orders.getOrders()).single.syncState.name, 'conflict');
    expect((await store.services.getServices()).single.syncState.name, 'conflict');
  });
}
