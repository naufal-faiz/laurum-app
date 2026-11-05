import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/demo_seeder.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';

void main() {
  test('existing business rows prevent fixture injection', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await db.customStatement('INSERT INTO customers(id,owner_id,created_at,name) VALUES(?,?,?,?)', [
      'existing',
      'owner',
      DateTime(2026).toIso8601String(),
      'Existing business',
    ]);
    await DemoSeeder(db, 'owner', OutboxWriter(db, DriftTransactionRunner(db))).run();
    expect((await db.select(db.customerRecords).get()).single.id, 'existing');
    expect(await db.select(db.orderRecords).get(), isEmpty);
    expect(await db.select(db.outboxRecords).get(), isEmpty);
    expect(await db.select(db.localSettingRecords).get(), isEmpty);
  });
  test('failed demo seed rolls back every table and marker then retries exactly once', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final seed = DemoSeeder(db, 'owner', OutboxWriter(db, DriftTransactionRunner(db)));
    await db.customStatement(
      "CREATE TRIGGER fault BEFORE INSERT ON payments BEGIN SELECT RAISE(ABORT, 'injected'); END",
    );
    await expectLater(seed.run(), throwsA(anything));
    for (final table in db.allTables) {
      expect(
        await db.customSelect('SELECT 1 FROM ${table.actualTableName} LIMIT 1').get(),
        isEmpty,
      );
    }
    await db.customStatement('DROP TRIGGER fault');
    await seed.run();
    expect((await db.select(db.orderRecords).get()).length, 16);
    final count = (await db.select(db.outboxRecords).get()).length;
    await seed.run();
    expect((await db.select(db.outboxRecords).get()).length, count);
  });
}
