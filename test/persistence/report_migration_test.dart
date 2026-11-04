import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/sql_timestamp.dart';

import 'generated/schema.dart';
import 'generated/schema_v3.dart' as v3;

void main() {
  test('v3 -> v4 backfills range keys without changing original savings timestamps', () async {
    final verifier = SchemaVerifier(GeneratedHelper());
    final schema = await verifier.schemaAt(3);
    final old = v3.DatabaseAtV3(schema.newConnection());
    await old.customStatement(
      "INSERT INTO customers(id,owner_id,created_at,name) VALUES('c','owner','2026-10-16T03:00:00Z','Nama')",
    );
    await old.customStatement(
      "INSERT INTO savings_entries(id,owner_id,created_at,customer_id,kind,amount,method) VALUES('s','owner','2026-10-16T03:00:00Z','c','setor',10,'tunai')",
    );
    await old.customStatement(
      "INSERT INTO expense_categories(id,owner_id,created_at,name) VALUES('cat','owner','2026-10-16T03:00:00Z','Sabun')",
    );
    await old.customStatement(
      "INSERT INTO expenses(id,owner_id,created_at,category_id,amount,spent_at) VALUES('e','owner','2026-10-16T03:00:00Z','cat',10,'2026-10-16T10:00:00.000001+07:00')",
    );
    await old.close();
    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, 4);
    final savings = await db
        .customSelect('SELECT created_at,created_key FROM savings_entries')
        .getSingle();
    expect(savings.read<String>('created_at'), '2026-10-16T03:00:00Z');
    expect(savings.read<String>('created_key'), '2026-10-16T03:00:00.000000Z');
    final expense = await db.customSelect('SELECT spent_at FROM expenses').getSingle();
    expect(
      expense.read<String>('spent_at'),
      sqlTimestamp(DateTime.parse('2026-10-16T03:00:00.000001Z')),
    );
    expect(await db.select(db.outboxRecords).get(), isEmpty);
  });
}
