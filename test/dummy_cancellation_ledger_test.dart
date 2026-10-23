import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/cancellation.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/reports/data/report_fixtures.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  test('paid order cannot be cancelled without its payment corrections', () async {
    final container = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(container.dispose);
    final orders = container.read(orderRepositoryProvider);
    final order = (await orders.getOrderById('ord-0139'))!;
    await expectLater(
      orders.updateOrderStatus(order.id, OrderStatus.dibatalkan),
      throwsStateError,
    );
    expect(await orders.getOrderById(order.id), order);
    final reports = container.read(reportRepositoryProvider);
    final before = await reports.getReport(weekRange);
    final result = cancelOrder(
      order,
      payments: await orders.getAllPayments(),
      savings: await container.read(savingsRepositoryProvider).getAllEntries(),
      correctionPrefix: 'cancel-139',
      at: DateTime(2026, 10, 16, 11),
    );
    await orders.saveOrder(result.order, payments: result.payments, events: [result.event]);
    final after = await reports.getReport(weekRange);
    expect(after.revenue, before.revenue - 25000);
    expect(after.cashIn, before.cashIn - 25000);
    expect(after.activeOutstanding, before.activeOutstanding);
  });
}
