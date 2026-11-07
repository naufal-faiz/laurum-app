import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/report_indexes_migration.dart';
import 'package:laurum/core/persistence/sync_groups_migration.dart';

Future<void> migrateSchema(AppDatabase db, Migrator m, int from, int to) async {
  if (to != 5 || from < 1 || from > 4) {
    throw UnsupportedError('Migration required from $from to $to');
  }
  if (from < 4) await migrateReportIndexes(db, m, from, 4);
  await migrateSyncGroups(db, m, from < 4 ? 4 : from, 5);
}
