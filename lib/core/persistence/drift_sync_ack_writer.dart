import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/sync/sync_table_names.dart';

class DriftSyncAckWriter {
  DriftSyncAckWriter(this.db);
  final AppDatabase db;

  Future<void> ackGroup(String groupId, Set<String> changeIds) async {
    if (changeIds.isEmpty) return;
    final rows =
        await (db.select(db.outboxRecords)..where(
              (t) => t.groupId.equals(groupId) & t.id.isIn(changeIds),
            ))
            .get();
    await (db.delete(db.outboxRecords)..where(
          (t) => t.groupId.equals(groupId) & t.id.isIn(changeIds),
        ))
        .go();
    for (final row in rows) {
      await _setSynced(row.targetTable, row.rowId);
    }
  }

  Future<void> markConflict(String groupId, String code) async {
    final rows = await (db.select(
      db.outboxRecords,
    )..where((t) => t.groupId.equals(groupId))).get();
    await db.customStatement(
      'UPDATE outbox SET conflict_code = ?, last_error = ? WHERE group_id = ?',
      [code, code, groupId],
    );
    for (final row in rows) {
      if (!syncPushTables.contains(row.targetTable)) continue;
      await db.customStatement(
        'UPDATE "${row.targetTable}" SET sync_state = ? WHERE id = ?',
        ['conflict', row.rowId],
      );
    }
  }

  Future<void> _setSynced(String table, String rowId) async {
    if (!syncPushTables.contains(table)) return;
    await db.customStatement(
      'UPDATE "$table" SET sync_state = ? WHERE id = ? '
      'AND NOT EXISTS (SELECT 1 FROM outbox WHERE table_name = ? AND row_id = ?)',
      ['synced', rowId, table, rowId],
    );
  }
}
