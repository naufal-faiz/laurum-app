import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/data/payment_fixtures.dart';
import 'package:laurum/features/reports/data/report_fixtures.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  late ProviderContainer container;
  setUp(() => container = ProviderContainer(overrides: dummyRepositoryOverrides));
  tearDown(() => container.dispose());

  test('public repository provider notifies subscribers after writes', () async {
    var notifications = 0;
    final sub = container.listen(customerRepositoryProvider, (_, _) => notifications++);
    final repo = container.read(customerRepositoryProvider);
    await repo.deleteCustomer('cust-001');
    await container.pump();
    expect(notifications, 1);
    expect(await repo.getCustomerById('cust-001'), isNull);
    sub.close();
  });

  test('returned order list cannot silently mutate repository state', () async {
    final repo = container.read(orderRepositoryProvider);
    final orders = await repo.getOrders();
    expect(orders.clear, throwsUnsupportedError);
    expect(await repo.getOrders(), isNotEmpty);
  });

  test('retrying save does not duplicate items or immutable payments', () async {
    final repo = container.read(orderRepositoryProvider);
    final order = (await repo.getOrderById('ord-0141'))!;
    final items = await repo.getItemsByOrderId(order.id);
    final payments = await repo.getPaymentsByOrderId(order.id);
    await repo.saveOrder(order, items: items, payments: payments);
    await repo.saveOrder(order, items: items, payments: payments);
    expect(await repo.getItemsByOrderId(order.id), items);
    expect(await repo.getPaymentsByOrderId(order.id), payments);
    await repo.addPayment(paymentFixtures.last);
    expect(await repo.getPaymentsByOrderId(order.id), payments);
  });

  test('deleting an existing expense rebuilds the historical baseline', () async {
    final repo = container.read(reportRepositoryProvider);
    expect((await repo.getReport(weekRange)).expenses, 850000);
    await container.read(expenseRepositoryProvider).deleteExpense('exp-018');
    expect((await repo.getReport(weekRange)).expenses, 740000);
    expect((await repo.getReport(todayRange)).expenses, 35000);
    expect((await repo.getReport(monthRange)).expenses, 1740000);
  });
}
