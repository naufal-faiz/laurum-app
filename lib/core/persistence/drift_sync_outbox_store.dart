import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/sync/sync_change.dart';
import 'package:laurum/core/sync/sync_group.dart';
import 'package:laurum/core/sync/sync_outbox_store.dart';

class DriftSyncOutboxStore implements SyncOutboxStore {
  DriftSyncOutboxStore(this.db);
  final AppDatabase db;
  static final _uuid = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$');

  @override
  Future<SyncGroup?> nextGroup() async {
    final first = await db
        .customSelect(
          'SELECT group_id FROM outbox WHERE group_id IS NOT NULL '
          'AND requires_recovery = 0 AND conflict_code IS NULL '
          'GROUP BY group_id ORDER BY MIN(rowid) LIMIT 1',
        )
        .getSingleOrNull();
    if (first == null) return null;
    final groupId = first.read<String>('group_id');
    final rows =
        await (db.select(db.outboxRecords)
              ..where((t) => t.groupId.equals(groupId))
              ..orderBy([(t) => OrderingTerm(expression: t.groupSeq)]))
            .get();
    return SyncGroup(groupId, [for (final row in rows) _change(row)]);
  }

  @override
  Future<int> pendingCount() => _count('SELECT COUNT(*) AS n FROM outbox');
  @override
  Future<int> conflictCount() =>
      _count('SELECT COUNT(*) AS n FROM outbox WHERE conflict_code IS NOT NULL');
  @override
  Future<int> legacyCount() =>
      _count('SELECT COUNT(*) AS n FROM outbox WHERE requires_recovery = 1');

  @override
  Future<List<SyncChange>> legacyChanges() async => [
    for (final row
        in await db
            .customSelect('SELECT * FROM outbox WHERE requires_recovery = 1 ORDER BY rowid')
            .get())
      _change(db.outboxRecords.map(row.data)),
  ];

  @override
  Future<void> ackGroup(String groupId, Set<String> changeIds) async {
    if (changeIds.isEmpty) return;
    await (db.delete(db.outboxRecords)..where(
          (t) => t.groupId.equals(groupId) & t.id.isIn(changeIds),
        ))
        .go();
  }

  @override
  Future<void> recordFailure(String groupId, String code) => db.customStatement(
    'UPDATE outbox SET attempts = attempts + 1, last_error = ? WHERE group_id = ?',
    [code, groupId],
  );

  @override
  Future<void> markConflict(String groupId, String code) => db.customStatement(
    'UPDATE outbox SET conflict_code = ?, last_error = ? WHERE group_id = ?',
    [code, code, groupId],
  );

  @override
  Future<void> recoverLegacyGroup(String groupId, List<String> changeIds) async {
    if (!_uuid.hasMatch(groupId) ||
        changeIds.isEmpty ||
        changeIds.toSet().length != changeIds.length) {
      throw ArgumentError('Invalid legacy recovery plan');
    }
    await db.transaction(() async {
      for (var index = 0; index < changeIds.length; index++) {
        final updated =
            await (db.update(db.outboxRecords)..where(
                  (t) => t.id.equals(changeIds[index]) & t.requiresRecovery.equals(true),
                ))
                .write(
                  OutboxRecordsCompanion(
                    groupId: Value(groupId),
                    groupSeq: Value(index + 1),
                    requiresRecovery: const Value(false),
                  ),
                );
        if (updated != 1) throw StateError('Legacy row is missing or already recovered');
      }
    });
  }

  Future<int> _count(String sql) async => (await db.customSelect(sql).getSingle()).read<int>('n');

  SyncChange _change(OutboxEntry row) => SyncChange(
    changeId: row.id,
    table: row.targetTable,
    rowId: row.rowId,
    op: row.op,
    payload: Map<String, Object?>.from(jsonDecode(row.payload) as Map),
  );
}
