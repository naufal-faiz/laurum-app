import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/sync/sync_cursor_store.dart';
import 'package:laurum/core/sync/sync_pull_cursor.dart';
import 'package:laurum/core/sync/sync_table_names.dart';

class DriftSyncCursorStore implements SyncCursorStore {
  DriftSyncCursorStore(this.db);
  final AppDatabase db;

  @override
  Future<SyncCursor> read(String table) async {
    _check(table);
    final row = await (db.select(
      db.syncCursorRecords,
    )..where((t) => t.targetTable.equals(table))).getSingleOrNull();
    if (row == null) return const SyncCursor();
    return SyncCursor(updatedAt: row.updatedAt, id: row.lastId);
  }

  @override
  Future<void> save(String table, SyncCursor cursor) async {
    _check(table);
    await db
        .into(db.syncCursorRecords)
        .insertOnConflictUpdate(
          SyncCursorRecordsCompanion.insert(
            targetTable: table,
            updatedAt: Value(cursor.updatedAt),
            lastId: Value(cursor.id),
          ),
        );
  }

  void _check(String table) {
    if (!syncPullTables.contains(table)) throw ArgumentError('Unknown sync table: $table');
  }
}
