import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/features/customers/data/drift_savings_repository.dart';
import 'package:laurum/features/expenses/data/drift_expense_repository.dart';
import 'package:laurum/features/orders/data/drift_order_repository.dart';
import 'package:laurum/features/reports/data/drift_report_repository.dart';

import '../contracts/report_contract.dart';
import 'report_seed.dart';

void main() {
  group(
    'Drift report contract',
    () => runReportRepositoryContract(({required bool seeded}) async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final writer = OutboxWriter(db, DriftTransactionRunner(db));
      if (seeded) await seedReportLedger(db, 'owner-001', writer);
      return (
        reports: DriftReportRepository(db, 'owner-001'),
        orders: DriftOrderRepository(db, 'owner-001', writer),
        expenses: DriftExpenseRepository(db, 'owner-001', writer),
        savings: DriftSavingsRepository(db, 'owner-001', writer),
      );
    }),
  );
}
