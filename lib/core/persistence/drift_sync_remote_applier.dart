import 'package:drift/drift.dart';
import 'package:laurum/core/domain/customer_search.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/remote_value_normalizer.dart';
import 'package:laurum/core/persistence/sql_timestamp.dart';
import 'package:laurum/core/sync/sync_remote_applier.dart';
import 'package:laurum/core/sync/sync_table_names.dart';

class DriftSyncRemoteApplier implements SyncRemoteApplier {
  DriftSyncRemoteApplier(this.db, this.ownerId);
  final AppDatabase db;
  final String ownerId;
  final _columns = <String, Map<String, String>>{};
  static final _uuid = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
  );

  @override
  Future<void> apply(String table, List<Map<String, Object?>> rows) async {
    if (!syncPullTables.contains(table)) throw ArgumentError('Unknown sync table: $table');
    if (rows.isEmpty) return;
    final columns = await _tableColumns(table);
    await db.transaction(() async {
      for (final row in rows) {
        await _applyRow(table, row, columns);
      }
    });
  }

  Future<void> _applyRow(
    String table,
    Map<String, Object?> row,
    Map<String, String> columns,
  ) async {
    final id = row['id'];
    if (id is! String || !_uuid.hasMatch(id)) throw StateError('Invalid remote row id');
    if (row['owner_id'] != ownerId) throw StateError('Remote row belongs to another owner');
    final pending = await db
        .customSelect(
          'SELECT 1 FROM outbox WHERE table_name = ? AND row_id = ? LIMIT 1',
          variables: [Variable(table), Variable(id)],
        )
        .get();
    if (pending.isNotEmpty) return;
    final values = <String, Object?>{};
    for (final entry in row.entries) {
      final type = columns[entry.key];
      if (type != null) values[entry.key] = normalizeRemoteValue(entry.key, type, entry.value);
    }
    values['sync_state'] = 'synced';
    if (table == 'customers') {
      values['name_key'] = customerNameKey(values['name'] as String? ?? '');
      values['phone_key'] = customerPhoneKey(values['phone'] as String? ?? '');
    }
    if (table == 'savings_entries') {
      values['created_key'] = sqlTimestamp(DateTime.parse(values['created_at']! as String));
    }
    final names = values.keys.toList();
    final updates = names
        .where((name) => name != 'id')
        .map((name) => '${_quote(name)} = excluded.${_quote(name)}')
        .join(', ');
    await db.customStatement(
      'INSERT INTO ${_quote(table)} (${names.map(_quote).join(', ')}) '
      'VALUES (${List.filled(names.length, '?').join(', ')}) '
      'ON CONFLICT("id") DO UPDATE SET $updates',
      [for (final name in names) values[name]],
    );
  }

  Future<Map<String, String>> _tableColumns(String table) async {
    final cached = _columns[table];
    if (cached != null) return cached;
    final rows = await db.customSelect('PRAGMA table_info(${_quote(table)})').get();
    final map = {
      for (final row in rows) row.read<String>('name'): row.read<String>('type').toUpperCase(),
    };
    return _columns[table] = map;
  }

  String _quote(String name) => '"${name.replaceAll('"', '""')}"';
}
