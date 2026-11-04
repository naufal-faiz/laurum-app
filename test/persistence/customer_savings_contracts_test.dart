import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/features/customers/data/drift_customer_repository.dart';
import 'package:laurum/features/customers/data/drift_savings_repository.dart';

import '../contracts/customer_contract.dart';
import '../contracts/savings_contract.dart';

void main() {
  late AppDatabase db;
  late OutboxWriter writer;
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    writer = OutboxWriter(db, DriftTransactionRunner(db));
  });
  tearDown(() => db.close());
  group(
    'Drift Customer contract',
    () => runCustomerRepositoryContract(() => DriftCustomerRepository(db, 'owner', writer)),
  );
  group(
    'Drift Savings contract',
    () => runSavingsRepositoryContract(() async {
      final customers = DriftCustomerRepository(db, 'owner', writer);
      await customers.saveCustomer(contractCustomer('c'));
      await customers.saveCustomer(contractCustomer('other'));
      return DriftSavingsRepository(db, 'owner', writer);
    }),
  );
}
