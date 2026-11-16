import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/remote_value_normalizer.dart';

/// Sync timestamps/status are persisted but do not invalidate business screens.
/// [table] and columns have already been validated by the remote applier.
Future<bool> remoteRowChangesBusinessData(
  AppDatabase db,
  String table,
  Map<String, Object?> values,
  Map<String, String> columns,
) async {
  final current = await db
      .customSelect(
        'SELECT * FROM "$table" WHERE id = ?',
        variables: [Variable<String>(values['id']! as String)],
      )
      .getSingleOrNull();
  if (current == null) return true;
  for (final entry in values.entries) {
    if (entry.key == 'updated_at' || entry.key == 'sync_state') continue;
    final previous = normalizeRemoteValue(entry.key, columns[entry.key]!, current.data[entry.key]);
    if (previous != entry.value) return true;
  }
  return false;
}
