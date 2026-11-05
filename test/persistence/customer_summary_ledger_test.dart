import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/customers/data/drift_customer_repository.dart';
import 'package:laurum/features/customers/data/drift_savings_repository.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/orders/data/drift_order_repository.dart';

void main() {
  test('Drift customer with a legacy fixture ID has no invented historical orders', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final writer = OutboxWriter(db, DriftTransactionRunner(db));
    final customers = DriftCustomerRepository(db, 'owner', writer);
    final c = ProviderContainer(
      overrides: [
        customerRepositoryProvider.overrideWithValue(customers),
        orderRepositoryProvider.overrideWithValue(DriftOrderRepository(db, 'owner', writer)),
        savingsRepositoryProvider.overrideWithValue(DriftSavingsRepository(db, 'owner', writer)),
      ],
    );
    addTearDown(() async {
      c.dispose();
      await db.close();
    });
    await customers.saveCustomer(
      Customer(
        id: 'cust-001',
        ownerId: 'owner',
        createdAt: DateTime(2026),
        name: 'New business',
      ),
    );
    final row = (await c.read(customerSummariesProvider.future)).single;
    expect(row.orderCount, 0);
    expect(row.historyTotal, 0);
    expect(row.debt, 0);
    expect(row.savings, 0);
  });
}
