import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/core/persistence/sql_timestamp.dart';
import 'package:laurum/features/reports/data/drift_report_repository.dart';

import 'report_seed.dart';

void main() {
  test('report balances and flows are owner scoped and range keys use indexes', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await seedReportLedger(db, 'owner-001', OutboxWriter(db, DriftTransactionRunner(db)));
    final range = ReportRange(DateTime(2026, 10, 12), DateTime(2026, 10, 19));
    final foreign = DriftReportRepository(db, 'foreign');
    final t = await foreign.getReport(range);
    expect(
      (t.revenue, t.cashIn, t.expenses, t.savingsBalance, t.activeOutstanding),
      (0, 0, 0, 0, 0),
    );
    expect(await foreign.getTopServices(range), isEmpty);
    expect(await foreign.getUnpaidCount(), 0);
    for (final (table, column, index) in [
      ('expenses', 'spent_at', 'expenses_owner_spent'),
      ('savings_entries', 'created_key', 'savings_owner_created'),
    ]) {
      final rows = await db
          .customSelect(
            'EXPLAIN QUERY PLAN SELECT * FROM $table '
            'WHERE owner_id = ? AND $column >= ? AND $column < ?',
            variables: [
              'owner-001',
              sqlTimestamp(range.start),
              sqlTimestamp(range.end),
            ].map(Variable<String>.new).toList(),
          )
          .get();
      expect(rows.map((r) => r.read<String>('detail')).join('\n'), contains(index));
    }
  });
}
