import 'package:drift/drift.dart' show Value;
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_local_settings_repository.dart';

import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;

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
    await verifier.migrateAndValidate(db, 4);
    final settings = DriftLocalSettingsRepository(db);
    await db.validateDatabaseSchema();
    expect(await settings.getInt('counter'), 143);
  });
}
