import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/device_registrar.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';

void main() {
  late AppDatabase db;
  late DeviceRegistrar registrar;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    registrar = DeviceRegistrar(
      db,
      'owner-1',
      OutboxWriter(db, DriftTransactionRunner(db)),
      clock: () => DateTime.utc(2026, 11, 9, 12),
    );
  });
  tearDown(() => db.close());

  test('registers one device row per install and keeps a stable code', () async {
    await registrar.ensureRegistered();
    await registrar.ensureRegistered();
    final rows = await db.select(db.deviceRecords).get();
    expect(rows, hasLength(1));
    expect(rows.single.ownerId, 'owner-1');
    expect(rows.single.code, await registrar.code());
    final outbox = await db.select(db.outboxRecords).get();
    expect(outbox, hasLength(1), reason: 'the row must reach the server once');
    expect(outbox.single.targetTable, 'devices');
    expect(outbox.single.payload, contains(rows.single.code));
  });

  test('a second account on the same install gets its own device row', () async {
    await registrar.ensureRegistered();
    final other = DeviceRegistrar(
      db,
      'owner-2',
      OutboxWriter(db, DriftTransactionRunner(db)),
    );
    await other.ensureRegistered();
    final rows = await db.select(db.deviceRecords).get();
    expect(rows.map((r) => r.ownerId).toSet(), {'owner-1', 'owner-2'});
    expect(rows.first.code, rows.last.code, reason: 'same install, same code');
  });
}
