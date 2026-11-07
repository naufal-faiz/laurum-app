import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_sync_outbox_store.dart';

import '../sync/sync_store_contract.dart';

void main() {
  late AppDatabase db;
  runSyncStoreContract(
    name: 'Drift',
    store: () {
      db = AppDatabase(NativeDatabase.memory());
      return DriftSyncOutboxStore(db);
    },
    seedGroup: (_, group) async {
      for (var index = 0; index < group.changes.length; index++) {
        final change = group.changes[index];
        await db
            .into(db.outboxRecords)
            .insert(
              OutboxRecordsCompanion.insert(
                id: change.changeId,
                targetTable: change.table,
                rowId: change.rowId,
                op: change.op,
                payload: jsonEncode(change.payload),
                createdAt: DateTime.utc(2026, 11, 6),
                groupId: Value(group.groupId),
                groupSeq: Value(index + 1),
              ),
            );
      }
    },
    seedLegacy: (_, changes) async {
      for (final change in changes) {
        await db
            .into(db.outboxRecords)
            .insert(
              OutboxRecordsCompanion.insert(
                id: change.changeId,
                targetTable: change.table,
                rowId: change.rowId,
                op: change.op,
                payload: jsonEncode(change.payload),
                createdAt: DateTime.utc(2026, 11, 6),
                requiresRecovery: const Value(true),
              ),
            );
      }
    },
    teardown: () => db.close(),
  );

  group('sync_state follows the outbox', () {
    late AppDatabase local;
    late DriftSyncOutboxStore store;
    const owner = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
    const customer = '10000000-0000-4000-8000-000000000001';
    const firstGroup = '20000000-0000-4000-8000-000000000001';
    const secondGroup = '20000000-0000-4000-8000-000000000002';

    setUp(() async {
      local = AppDatabase(NativeDatabase.memory());
      store = DriftSyncOutboxStore(local);
      await local
          .into(local.customerRecords)
          .insert(
            CustomerRecordsCompanion.insert(
              id: customer,
              ownerId: owner,
              createdAt: DateTime.utc(2026, 11, 6),
              name: 'Sari',
            ),
          );
    });
    tearDown(() => local.close());

    Future<void> enqueue(String id, String group, int seq) => local
        .into(local.outboxRecords)
        .insert(
          OutboxRecordsCompanion.insert(
            id: id,
            targetTable: 'customers',
            rowId: customer,
            op: 'upsert',
            payload: '{}',
            createdAt: DateTime.utc(2026, 11, 6),
            groupId: Value(group),
            groupSeq: Value(seq),
          ),
        );

    test('ack marks the row synced only when no newer change is queued', () async {
      await enqueue('30000000-0000-4000-8000-000000000001', firstGroup, 1);
      await store.ackGroup(firstGroup, {'30000000-0000-4000-8000-000000000001'});
      expect((await local.select(local.customerRecords).getSingle()).syncState, 'synced');
      await enqueue('30000000-0000-4000-8000-000000000002', firstGroup, 1);
      await enqueue('30000000-0000-4000-8000-000000000003', secondGroup, 1);
      await store.ackGroup(firstGroup, {'30000000-0000-4000-8000-000000000002'});
      expect((await local.select(local.customerRecords).getSingle()).syncState, 'synced');
      await store.ackGroup(secondGroup, {'30000000-0000-4000-8000-000000000003'});
      expect((await local.select(local.customerRecords).getSingle()).syncState, 'synced');
    });

    test('a row remains pending while another outbox group is queued', () async {
      await local.customStatement("UPDATE customers SET sync_state = 'pending'");
      await enqueue('30000000-0000-4000-8000-000000000004', firstGroup, 1);
      await enqueue('30000000-0000-4000-8000-000000000005', secondGroup, 1);
      await store.ackGroup(firstGroup, {'30000000-0000-4000-8000-000000000004'});
      expect((await local.select(local.customerRecords).getSingle()).syncState, 'pending');
    });

    test('conflict marks the local row so it cannot look synced', () async {
      await enqueue('30000000-0000-4000-8000-000000000006', firstGroup, 1);
      await store.markConflict(firstGroup, 'unique_conflict');
      expect((await local.select(local.customerRecords).getSingle()).syncState, 'conflict');
    });
  });
}
