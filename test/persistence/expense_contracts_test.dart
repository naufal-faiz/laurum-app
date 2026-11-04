import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/features/expenses/data/drift_expense_repository.dart';

import '../contracts/expense_contract.dart';

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());
  group(
    'Drift expense contract',
    () => runExpenseRepositoryContract(
      () => DriftExpenseRepository(db, 'owner', OutboxWriter(db, DriftTransactionRunner(db))),
    ),
  );
}
