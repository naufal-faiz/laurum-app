import 'package:drift/drift.dart';
import 'package:laurum/core/domain/customer_search.dart';
import 'package:laurum/core/persistence/app_database.dart';

Future<void> migrateCustomerKeys(AppDatabase db, Migrator m, int from, int to) async {
  if (from != 1 || to != 2) throw UnsupportedError('Migration required from $from to $to');
  await db.transaction(() async {
    await m.addColumn(db.customerRecords, db.customerRecords.nameKey);
    await m.addColumn(db.customerRecords, db.customerRecords.phoneKey);
    final rows = await db.customSelect('SELECT id, name, phone FROM customers').get();
    for (final row in rows) {
      await db.customStatement('UPDATE customers SET name_key = ?, phone_key = ? WHERE id = ?', [
        customerNameKey(row.read<String>('name')),
        customerPhoneKey(row.read<String>('phone')),
        row.read<String>('id'),
      ]);
    }
    await db.customStatement('DROP INDEX customers_active_phone');
    // Legacy aliases that collide abort the migration; no customer is silently merged.
    await m.createIndex(db.customersActivePhone);
    await m.createIndex(db.customersNamePrefix);
    await m.createIndex(db.customersPhonePrefix);
    await m.createIndex(db.customersOwnerUpdated);
    await m.createIndex(db.savingsOwnerUpdated);
  });
}
