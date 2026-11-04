import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/customer_keys_migration.dart';
import 'package:laurum/core/persistence/sql_timestamp.dart';

Future<void> migrateOrderIndexes(AppDatabase db, Migrator m, int from, int to) async {
  if (from < 1 || from > 2 || to != 3) {
    throw UnsupportedError('Migration required from $from to $to');
  }
  await db.transaction(() async {
    if (from == 1) await migrateCustomerKeys(db, m, 1, 2);
    for (final (table, column) in [('orders', 'entered_at'), ('payments', 'paid_at')]) {
      final rows = await db.customSelect('SELECT id, $column FROM $table').get();
      for (final row in rows) {
        await db.customStatement('UPDATE $table SET $column = ? WHERE id = ?', [
          sqlTimestamp(DateTime.parse(row.read<String>(column))),
          row.read<String>('id'),
        ]);
      }
    }
    await m.createIndex(db.ordersOwnerStatus);
    await m.createIndex(db.ordersOwnerEntered);
    await m.createIndex(db.paymentsOwnerPaid);
  });
}
