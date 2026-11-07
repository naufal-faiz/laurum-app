import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/features/orders/data/drift_order_repository.dart';

import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

void main() {
  for (final version in [1, 2]) {
    test('v$version -> current retains old records and normalizes precise time ranges', () async {
      final verifier = SchemaVerifier(GeneratedHelper());
      final schema = await verifier.schemaAt(version);
      final GeneratedDatabase old = version == 1
          ? v1.DatabaseAtV1(schema.newConnection())
          : v2.DatabaseAtV2(schema.newConnection());
      await old.customStatement(
        "INSERT INTO customers (id, owner_id, created_at, name) VALUES ('c', 'owner', '2026-11-04T00:00:00Z', 'Lama')",
      );
      await old.customStatement('''INSERT INTO orders (id, owner_id, created_at, order_no,
        customer_id, status, source, entered_at, estimated_at, subtotal, total)
        VALUES ('o', 'owner', '2026-11-04T00:00:00Z', 'A-0042', 'c', 'diproses', 'kasir',
        '2026-11-04T10:00:00.000001+07:00', '2026-11-05T10:00:00+07:00', 100, 100)''');
      await old.customStatement('''INSERT INTO payments (id, owner_id, created_at,
        order_id, method, amount, received, paid_at) VALUES ('p', 'owner', '2026-11-04T00:00:00Z',
        'o', 'tunai', 100, 100, '2026-11-04T03:00:00.000001Z')''');
      await old.close();
      final db = AppDatabase(schema.newConnection());
      addTearDown(db.close);
      await verifier.migrateAndValidate(db, 5);
      final repo = DriftOrderRepository(db, 'owner', OutboxWriter(db, DriftTransactionRunner(db)));
      final start = DateTime.parse('2026-11-04T03:00:00.000001Z').toLocal();
      final range = ReportRange(start, start.add(const Duration(microseconds: 1)));
      expect((await repo.getOrdersInRange(range)).single.id, 'o');
      expect((await repo.getPaymentsInRange(range)).single.id, 'p');
      expect((await repo.getOrderById('o'))!.enteredAt, start);
      final text = await db.customSelect('SELECT entered_at FROM orders').getSingle();
      expect(text.read<String>('entered_at'), '2026-11-04T03:00:00.000001Z');
      expect(await db.select(db.outboxRecords).get(), isEmpty);
    });
  }
}
