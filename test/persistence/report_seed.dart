import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/features/customers/data/customer_fixtures.dart';
import 'package:laurum/features/customers/data/drift_customer_repository.dart';
import 'package:laurum/features/customers/data/drift_savings_repository.dart';
import 'package:laurum/features/customers/data/savings_fixtures.dart';
import 'package:laurum/features/expenses/data/drift_expense_repository.dart';
import 'package:laurum/features/expenses/data/expense_fixtures.dart';
import 'package:laurum/features/orders/data/drift_order_repository.dart';
import 'package:laurum/features/orders/data/order_fixtures.dart';
import 'package:laurum/features/orders/data/order_item_fixtures.dart';
import 'package:laurum/features/orders/data/payment_fixtures.dart';
import 'package:laurum/features/services/data/drift_service_repository.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';

Future<void> seedReportLedger(AppDatabase db, String owner, OutboxWriter writer) =>
    writer.runner.run(() async {
      final customers = DriftCustomerRepository(db, owner, writer);
      final services = DriftServiceRepository(db, owner, writer);
      final orders = DriftOrderRepository(db, owner, writer);
      final expenses = DriftExpenseRepository(db, owner, writer);
      final savings = DriftSavingsRepository(db, owner, writer);
      for (final c in customerFixtures) {
        await customers.saveCustomer(c);
      }
      for (final s in serviceFixtures) {
        await services.saveService(s);
      }
      for (final c in expenseCategoryFixtures) {
        await expenses.saveCategory(c);
      }
      for (final o in orderFixtures) {
        await orders.saveOrder(
          o,
          items: orderItemFixtures.where((i) => i.orderId == o.id).toList(),
          payments: paymentFixtures.where((p) => p.orderId == o.id).toList(),
        );
      }
      for (final e in expenseFixtures) {
        await expenses.saveExpense(e);
      }
      for (final s in savingsFixtures) {
        await savings.addEntry(s);
      }
    });
