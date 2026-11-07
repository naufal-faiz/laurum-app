import 'package:drift/drift.dart' show Value;
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_local_settings_repository.dart';

import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v4.dart' as v4;

void main() {
  test('frozen v1 migrates to current schema and retains its data', () async {
    final verifier = SchemaVerifier(GeneratedHelper());
    final schema = await verifier.schemaAt(1);
    final oldDb = v1.DatabaseAtV1(schema.newConnection());
    await oldDb
        .into(oldDb.localSettings)
        .insert(
          v1.LocalSettingsCompanion.insert(key: 'counter', intValue: const Value(143)),
        );
    await oldDb.close();
    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, 5);
    final settings = DriftLocalSettingsRepository(db);
    await db.validateDatabaseSchema();
    expect(await settings.getInt('counter'), 143);
  });

  test('frozen v4 outbox becomes explicit legacy rows, never guessed groups', () async {
    final verifier = SchemaVerifier(GeneratedHelper());
    final schema = await verifier.schemaAt(4);
    final oldDb = v4.DatabaseAtV4(schema.newConnection());
    await oldDb
        .into(oldDb.outbox)
        .insert(
          v4.OutboxCompanion.insert(
            id: '10000000-0000-4000-8000-000000000001',
            tableName$: 'customers',
            rowId: '20000000-0000-4000-8000-000000000001',
            op: 'upsert',
            payload: '{"id":"20000000-0000-4000-8000-000000000001"}',
            createdAt: '2026-11-05T00:00:00.000Z',
          ),
        );
    await oldDb.close();
    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, 5);
    final row = await db.select(db.outboxRecords).getSingle();
    expect(row.groupId, isNull);
    expect(row.groupSeq, isNull);
    expect(row.requiresRecovery, isTrue);
    expect(row.conflictCode, isNull);
  });
}
