import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_local_settings_repository.dart';

import 'generated/schema.dart';
import 'generated/schema_v6.dart' as v6;

void main() {
  test('v6 AI proposals retain their content and gain nullable positive grams', () async {
    final verifier = SchemaVerifier(GeneratedHelper());
    final schema = await verifier.schemaAt(6);
    final old = v6.DatabaseAtV6(schema.newConnection());
    await old.customStatement(
      'INSERT INTO ai_proposals (id,owner_id,created_at,source_text,customer_name,phone,confidence) '
      'VALUES (?,?,?,?,?,?,?)',
      ['old-proposal', 'owner', '2026-11-20T00:00:00Z', 'Old message', 'Ani', '081200000001', 0.9],
    );
    await old.customStatement("INSERT INTO local_settings(key,int_value) VALUES('counter',19)");
    await old.close();
    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, 7);
    await db.validateDatabaseSchema();
    final row = await db.select(db.aiProposalRecords).getSingle();
    expect(row.sourceText, 'Old message');
    expect(row.customerName, 'Ani');
    expect(row.confidence, 0.9);
    expect(row.estimatedWeightGrams, isNull);
    expect(await DriftLocalSettingsRepository(db).getInt('counter'), 19);
    await db.customStatement('UPDATE ai_proposals SET estimated_weight_grams=2000');
    expect((await db.select(db.aiProposalRecords).getSingle()).estimatedWeightGrams, 2000);
    await expectLater(
      db.customStatement('UPDATE ai_proposals SET estimated_weight_grams=-1'),
      throwsA(anything),
    );
  });
}
