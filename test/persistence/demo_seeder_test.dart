import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/demo_seeder.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/features/reports/data/drift_report_repository.dart';

void main() {
  test('seed UUID deterministic, owner scoped, ledger exact and retry idempotent', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final writer = OutboxWriter(db, DriftTransactionRunner(db));
    final seed = DemoSeeder(db, 'account-a', writer);
    await seed.run();
    final uuid = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-5[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$');
    expect(seed.id('cust-001'), seed.id('cust-001'));
    expect(seed.id('cust-001'), isNot(DemoSeeder(db, 'account-b', writer).id('cust-001')));
    for (final table in db.allTables.where((t) => t.$columns.any((c) => c.$name == 'owner_id'))) {
      for (final row
          in await db.customSelect('SELECT id, owner_id FROM ${table.actualTableName}').get()) {
        expect(row.read<String>('id'), matches(uuid));
        expect(row.read<String>('owner_id'), 'account-a');
      }
    }
    expect((await db.select(db.customerRecords).get()).length, 48);
    final report = await DriftReportRepository(db, 'account-a').getReport(
      ReportRange(DateTime(2026, 10, 12), DateTime(2026, 10, 19)),
    );
    expect(report.revenue, 589000);
    expect(report.transactionCount, 14);
    expect(report.expenses, 850000);
    final pending = await db.select(db.outboxRecords).get();
    expect(pending, isNotEmpty);
    for (final change in pending) {
      final payload = jsonDecode(change.payload) as Map<String, dynamic>;
      expect(payload['owner_id'], 'account-a');
      expect(payload['id'], change.rowId);
      for (final key in ['customer_id', 'service_id', 'order_id', 'category_id', 'proposal_id']) {
        if (payload[key] != null) expect(payload[key], matches(uuid));
      }
    }
    expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
    await seed.run();
    expect((await db.select(db.outboxRecords).get()).length, pending.length);
  });
}
