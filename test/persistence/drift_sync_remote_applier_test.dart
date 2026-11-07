import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_sync_remote_applier.dart';
import 'package:laurum/core/persistence/sql_timestamp.dart';
import 'package:laurum/core/sync/sync_table_names.dart';

import 'sync_wire_rows.dart';

void main() {
  late AppDatabase db;
  late DriftSyncRemoteApplier applier;
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    applier = DriftSyncRemoteApplier(db, wireOwner);
  });
  tearDown(() => db.close());

  Future<void> applyAll() async {
    final rows = allWireRows();
    for (var index = 0; index < syncPullOrder.length; index++) {
      await applier.apply(syncPullOrder[index], [rows[index]]);
    }
  }

  test('all thirteen owner tables map wire rows into local tables', () async {
    await applyAll();
    for (final table in syncPullOrder) {
      final count = await db.customSelect('SELECT COUNT(*) AS n FROM "$table"').getSingle();
      expect(count.read<int>('n'), 1, reason: table);
    }
    final customer = await db.select(db.customerRecords).getSingle();
    expect(customer.name, ' Sari ');
    expect(customer.nameKey, 'sari');
    expect(customer.phoneKey, '081234567890');
    expect(customer.syncState, 'synced');
    expect(customer.createdAt, DateTime.utc(2026, 11, 6, 6));
    expect(customer.updatedAt, DateTime.utc(2026, 11, 6, 6, 29, 12, 123, 456));
    final received = await db.select(db.receiptSettingRecords).getSingle();
    expect(received.paperMm, 80);
    expect(received.showCustomer, isFalse);
    final savings = await db.select(db.savingsRecords).getSingle();
    expect(savings.createdKey, sqlTimestamp(DateTime.utc(2026, 11, 6, 6, 29, 12, 123, 456)));
    final entitlement = await db.select(db.entitlementRecords).getSingle();
    expect(entitlement.plan, 'pro');
    final order = await db.select(db.orderRecords).getSingle();
    expect(order.total, 7000);
    expect(order.enteredAt, DateTime.utc(2026, 11, 6, 6, 29, 12, 123, 456));
    expect(await db.select(db.outboxRecords).get(), isEmpty);
  });

  test('reapplying the same page is idempotent and keeps tombstones', () async {
    await applyAll();
    await applyAll();
    final count = await db.customSelect('SELECT COUNT(*) AS n FROM customers').getSingle();
    expect(count.read<int>('n'), 1);
    final doomed = {...customerRow(), 'deleted_at': wireAt};
    await applier.apply('customers', [doomed]);
    final customer = await db.select(db.customerRecords).getSingle();
    expect(customer.deletedAt, DateTime.utc(2026, 11, 6, 6, 29, 12, 123, 456));
  });

  test('a row with a pending outbox change is never overwritten by pull', () async {
    await applier.apply('customers', [customerRow()]);
    await db.customStatement("UPDATE customers SET sync_state = 'pending'");
    await db
        .into(db.outboxRecords)
        .insert(
          OutboxRecordsCompanion.insert(
            id: '10000000-0000-4000-8000-000000000020',
            targetTable: 'customers',
            rowId: wireCustomer,
            op: 'upsert',
            payload: '{}',
            createdAt: DateTime.utc(2026, 11, 6),
            groupId: const Value('10000000-0000-4000-8000-000000000021'),
            groupSeq: const Value(1),
          ),
        );
    await applier.apply('customers', [customerRow(name: 'Changed')]);
    final customer = await db.select(db.customerRecords).getSingle();
    expect(customer.name, ' Sari ');
    expect(customer.syncState, 'pending');
  });

  test('foreign owners, unknown tables and malformed ids are rejected', () async {
    await expectLater(
      applier.apply('customers', [customerRow(owner: wireOtherOwner)]),
      throwsStateError,
    );
    await expectLater(applier.apply('outbox', []), throwsArgumentError);
    await expectLater(
      applier.apply('customers', [
        {'id': 'not-a-uuid', 'owner_id': wireOwner},
      ]),
      throwsStateError,
    );
  });
}
