import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());
  test('current schema creates complete PRD tables without payment status', () async {
    await db.customSelect('SELECT 1').get();
    expect(db.schemaVersion, 2);
    expect(db.allTables.map((t) => t.actualTableName).toSet(), {
      'businesses',
      'devices',
      'customers',
      'services',
      'orders',
      'order_items',
      'payments',
      'savings_entries',
      'expense_categories',
      'expenses',
      'receipt_settings',
      'entitlements',
      'order_events',
      'outbox',
      'sync_cursors',
      'local_settings',
    });
    final orders = await db.customSelect('PRAGMA table_info(orders)').get();
    expect(orders.map((r) => r.read<String>('name')), isNot(contains('pay_status')));
    final savings = await db.customSelect('PRAGMA table_info(savings_entries)').get();
    expect(savings.map((r) => r.read<String>('name')), isNot(contains('deleted_at')));
    final fk = await db.customSelect('PRAGMA foreign_keys').getSingle();
    expect(fk.read<int>('foreign_keys'), 1);
    await db.validateDatabaseSchema();
  });
  test('schema verifier detects drift instead of silently accepting changed schema', () async {
    await db.customStatement('ALTER TABLE local_settings ADD COLUMN unexpected TEXT');
    await expectLater(db.validateDatabaseSchema(), throwsA(isA<SchemaMismatch>()));
  });
  test('payment corrections may be negative but money columns remain integer', () async {
    final columns = await db.customSelect('PRAGMA table_info(payments)').get();
    expect(
      columns.singleWhere((r) => r.read<String>('name') == 'amount').read<String>('type'),
      'INTEGER',
    );
    await db.customStatement(
      "INSERT INTO customers (id, owner_id, created_at, name) VALUES ('c', 'owner', '2026-10-16T00:00:00Z', 'Ratna')",
    );
    await db.customStatement('''INSERT INTO orders
      (id, owner_id, created_at, order_no, customer_id, status, source,
       discount, entered_at, estimated_at, subtotal, total)
      VALUES ('o', 'owner', '2026-10-16T00:00:00Z', 'A-0001', 'c', 'diproses', 'kasir',
              0, '2026-10-16T00:00:00Z', '2026-10-17T00:00:00Z', 100, 100)''');
    await db.customStatement('''INSERT INTO payments
      (id, owner_id, created_at, order_id, method, amount, received, paid_at)
      VALUES ('p', 'owner', '2026-10-16T00:00:00Z', 'o', 'tunai', -100, -100,
              '2026-10-16T00:00:00Z')''');
    expect((await db.select(db.paymentRecords).getSingle()).amount, -100);
  });
}
