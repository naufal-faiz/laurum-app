import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/business/data/business_fixtures.dart';
import 'package:laurum/features/reports/data/report_fixtures.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  test('creating then cancelling an order updates queue and report without reload', () async {
    final container = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(container.dispose);
    final orders = container.read(orderRepositoryProvider);
    final reports = container.read(reportRepositoryProvider);
    final before = await reports.getReport(weekRange);
    final topBefore = await reports.getTopServices(weekRange);
    final at = DateTime(2026, 10, 16, 11);
    final order = Order(
      id: 'new-143',
      ownerId: dummyOwnerId,
      createdAt: at,
      orderNo: 'A-0143',
      customerId: 'cust-001',
      status: OrderStatus.diproses,
      source: OrderSource.kasir,
      discount: 0,
      enteredAt: at,
      estimatedAt: DateTime(2026, 10, 18, 17),
      subtotal: 9000,
      total: 9000,
    );
    final item = OrderItem(
      id: 'new-item',
      ownerId: dummyOwnerId,
      createdAt: at,
      orderId: order.id,
      serviceId: 'srv-003',
      serviceName: 'Cuci setrika',
      unit: 'kg',
      qtyMilli: 1000,
      unitPrice: 9000,
      lineTotal: 9000,
    );
    await orders.saveOrder(order, items: [item]);
    expect((await orders.getOrders(status: OrderStatus.diproses)).length, 6);
    final after = await reports.getReport(weekRange);
    expect(after.revenue, before.revenue + 9000);
    expect(after.transactionCount, before.transactionCount + 1);
    expect(after.activeOutstanding, before.activeOutstanding + 9000);
    final topAfter = await reports.getTopServices(weekRange);
    expect(topAfter.first.revenue, topBefore.first.revenue + 9000);
    expect(topAfter.first.qtyMilli, topBefore.first.qtyMilli + 1000);
    await orders.updateOrderStatus(order.id, OrderStatus.dibatalkan);
    expect(await reports.getReport(weekRange), before);
    expect(await reports.getTopServices(weekRange), topBefore);
  });
}
