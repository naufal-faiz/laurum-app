import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/features/customers/data/drift_customer_repository.dart';
import 'package:laurum/features/orders/data/drift_order_repository.dart';
import 'package:laurum/features/services/data/drift_service_repository.dart';

import '../contracts/customer_contract.dart';
import '../contracts/order_contract.dart';
import '../domain_samples.dart';

void main() {
  late AppDatabase db;
  late OutboxWriter writer;
  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    writer = OutboxWriter(db, DriftTransactionRunner(db));
    await DriftCustomerRepository(db, 'owner', writer).saveCustomer(contractCustomer('c'));
    await DriftServiceRepository(db, 'owner', writer).saveService(service('s'));
  });
  tearDown(() => db.close());
  group(
    'Drift Order contract',
    () => runOrderRepositoryContract(() => DriftOrderRepository(db, 'owner', writer)),
  );
}
