import 'package:drift/drift.dart' show Value;
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/features/customers/data/customer_queries.dart';

import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;

Future<void> seedOldCustomers(v1.DatabaseAtV1 old, {bool collision = false}) async {
  await old
      .into(old.customers)
      .insert(
        v1.CustomersCompanion.insert(
          id: 'a',
          ownerId: 'owner',
          createdAt: '2026-10-16T00:00:00Z',
          name: 'Élodie',
          phone: const Value('+62 812-3456-7890'),
        ),
      );
  if (collision) {
    await old
        .into(old.customers)
        .insert(
          v1.CustomersCompanion.insert(
            id: 'b',
            ownerId: 'owner',
            createdAt: '2026-10-16T00:00:00Z',
            name: 'Lain',
            phone: const Value('081234567890'),
          ),
        );
  }
}

void main() {
  test('v1 -> v2 backfills indexed keys and preserves display values', () async {
    final verifier = SchemaVerifier(GeneratedHelper());
    final schema = await verifier.schemaAt(1);
    final old = v1.DatabaseAtV1(schema.newConnection());
    await seedOldCustomers(old);
    await old.close();
    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, 2);
    final rows = await readCustomers(db, 'owner', query: 'é');
    expect(rows.single.name, 'Élodie');
    expect(rows.single.phone, '+62 812-3456-7890');
    expect(rows.single.phoneKey, '081234567890');
    expect((await readCustomers(db, 'owner', query: '62812')).single.id, 'a');
    await db.validateDatabaseSchema();
  });
  test('legacy active phone collision rolls back migration without merging data', () async {
    final verifier = SchemaVerifier(GeneratedHelper());
    final schema = await verifier.schemaAt(1);
    final old = v1.DatabaseAtV1(schema.newConnection());
    await seedOldCustomers(old, collision: true);
    await old.close();
    final db = AppDatabase(schema.newConnection());
    await expectLater(db.customSelect('SELECT 1').get(), throwsA(isA<Exception>()));
    await db.close();
    final check = v1.DatabaseAtV1(schema.newConnection());
    addTearDown(check.close);
    expect(await check.select(check.customers).get(), hasLength(2));
    final columns = await check.customSelect('PRAGMA table_info(customers)').get();
    expect(columns.map((r) => r.read<String>('name')), isNot(contains('phone_key')));
  });
}
