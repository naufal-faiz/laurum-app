import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/ai_tables_migration.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/report_indexes_migration.dart';
import 'package:laurum/core/persistence/sync_groups_migration.dart';

Future<void> migrateSchema(AppDatabase db, Migrator m, int from, int to) async {
  if (to != 6 || from < 1 || from > 5) {
    throw UnsupportedError('Migration required from $from to $to');
  }
  if (from < 4) await migrateReportIndexes(db, m, from, 4);
  if (from < 5) await migrateSyncGroups(db, m, from < 4 ? 4 : from, 5);
  await migrateAiTables(db, m);
}
