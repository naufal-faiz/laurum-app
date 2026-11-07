import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
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
}
