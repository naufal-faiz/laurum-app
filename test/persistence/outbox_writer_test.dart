import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_local_settings_repository.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';

void main() {
  late AppDatabase db;
  late DriftTransactionRunner runner;
  late DriftLocalSettingsRepository settings;
  late OutboxWriter writer;
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    runner = DriftTransactionRunner(db);
    settings = DriftLocalSettingsRepository(db);
    writer = OutboxWriter(db, runner);
  });
  tearDown(() => db.close());
  Future<void> write() => writer.write(
    table: 'customers',
    rowId: 'row-id',
    payload: {'name': 'Ratna'},
    mutate: () => settings.setInt('written', 1),
  );
  test('data and outbox commit together with UUID and encoded payload', () async {
    await write();
    expect(await settings.getInt('written'), 1);
    final row = await db.select(db.outboxRecords).getSingle();
    expect(row.id[14], '4');
    expect(row.targetTable, 'customers');
    expect(row.rowId, 'row-id');
    expect(row.op, 'upsert');
    expect(jsonDecode(row.payload), {'name': 'Ratna'});
    expect(row.attempts, 0);
  });
  test('outer rollback removes both data and outbox', () async {
    await expectLater(
      runner.run(() async {
        await write();
        throw StateError('failed');
      }),
      throwsStateError,
    );
    expect(await settings.getInt('written'), isNull);
    expect(await db.select(db.outboxRecords).get(), isEmpty);
  });
  test('outbox insert failure rolls back data mutation', () async {
    await db.customStatement('DROP TABLE outbox');
    await expectLater(write(), throwsA(isA<Exception>()));
    expect(await settings.getInt('written'), isNull);
  });
  test('local or unknown table cannot enter sync outbox', () async {
    await expectLater(
      writer.write(
        table: 'local_settings',
        rowId: 'key',
        payload: {},
        mutate: () => settings.setInt('written', 1),
      ),
      throwsArgumentError,
    );
    expect(await settings.getInt('written'), isNull);
  });
}
