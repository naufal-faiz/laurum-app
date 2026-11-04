import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';

void main() {
  for (final utc in [false, true]) {
    test('timestamps retain subsecond precision and UTC identity, utc=$utc', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final local = DateTime(2026, 10, 16, 10, 45, 12, 123, 456);
      final at = utc ? local.toUtc() : local;
      await db
          .into(db.outboxRecords)
          .insert(
            OutboxRecordsCompanion.insert(
              id: 'outbox-id',
              targetTable: 'customers',
              rowId: 'customer-id',
              op: 'upsert',
              payload: '{}',
              createdAt: at,
            ),
          );
      final stored = (await db.select(db.outboxRecords).getSingle()).createdAt;
      expect(stored, at);
      expect(stored.isUtc, utc);
    });
  }
}
