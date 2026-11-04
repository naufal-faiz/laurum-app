import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/order_indexes_migration.dart';
import 'package:laurum/core/persistence/sql_timestamp.dart';

Future<void> migrateReportIndexes(AppDatabase db, Migrator m, int from, int to) async {
  if (from < 1 || from > 3 || to != 4) {
    throw UnsupportedError('Migration required from $from to $to');
  }
  await db.transaction(() async {
    if (from < 3) await migrateOrderIndexes(db, m, from, 3);
    await m.addColumn(db.savingsRecords, db.savingsRecords.createdKey);
    for (final (table, input, output) in [
      ('savings_entries', 'created_at', 'created_key'),
      ('expenses', 'spent_at', 'spent_at'),
    ]) {
      final rows = await db.customSelect('SELECT id, $input FROM $table').get();
      for (final row in rows) {
        await db.customStatement('UPDATE $table SET $output = ? WHERE id = ?', [
          sqlTimestamp(DateTime.parse(row.read<String>(input))),
          row.read<String>('id'),
        ]);
      }
    }
    await m.createIndex(db.savingsOwnerCreated);
    await m.createIndex(db.expensesOwnerSpent);
  });
}
