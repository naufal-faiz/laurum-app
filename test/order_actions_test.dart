import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/pages/antrean_data.dart';
import 'package:laurum/features/orders/pages/order_detail_controller.dart';
import 'package:laurum/features/orders/pages/order_detail_data.dart';
import 'package:laurum/features/orders/pages/order_payment_controller.dart';
import 'package:laurum/features/reports/data/report_fixtures.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/pages/checkout_state.dart';
import 'package:laurum/features/transactions/pages/transaction_draft.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  late ProviderContainer container;
  setUp(() => container = ProviderContainer(overrides: dummyRepositoryOverrides));
  tearDown(() => container.dispose());

  test('cancelling an unpaid order leaves reports and the queue', () async {
    final reports = container.read(reportRepositoryProvider);
    final before = await reports.getReport(weekRange);
    final detail = (await container.read(orderDetailProvider('ord-0142').future))!;
    expect(await container.read(orderActionsProvider.notifier).cancel(detail), isTrue);
    final order = await container.read(orderRepositoryProvider).getOrderById('ord-0142');
    expect(order!.status, OrderStatus.dibatalkan);
    final after = await reports.getReport(weekRange);
    expect(after.revenue, before.revenue - 31500);
    final queue = await container.read(antreanDataProvider.future);
    expect(queue.orders.where((item) => item.id == 'ord-0142'), isEmpty);
  });

  test('cancelling a paid order returns savings without double refund', () async {
    final savings = container.read(savingsRepositoryProvider);
    final start = await savings.getBalance('cust-001');
    container.read(transactionDraftProvider.notifier)
      ..selectCustomer('cust-001')
      ..add(serviceFixtures.firstWhere((service) => service.id == 'srv-003'))
      ..setQuantity('srv-003', 3500);
    final checkout = container.read(checkoutControllerProvider.notifier)
      ..setSavings(value: true, due: 31500);
    final orderId = (await checkout.save())!;
    expect(await savings.getBalance('cust-001'), start - 31500);

    final detail = (await container.read(orderDetailProvider(orderId).future))!;
    expect(await container.read(orderActionsProvider.notifier).cancel(detail), isTrue);
    expect(await savings.getBalance('cust-001'), start);
    final payments = await container.read(orderRepositoryProvider).getPaymentsByOrderId(orderId);
    expect(payments.fold(0, (sum, payment) => sum + payment.amount), 0);
  });

  test('recording a payment settles the note and rejects invalid amounts', () async {
    final detail = (await container.read(orderDetailProvider('ord-0142').future))!;
    final payments = container.read(orderPaymentProvider.notifier);
    expect(await payments.record(detail, amount: 0, method: PayMethod.tunai, received: 0), isFalse);
    expect(container.read(orderPaymentProvider).error, isNotNull);
    expect(
      await payments.record(detail, amount: 31500, method: PayMethod.tunai, received: 31500),
      isTrue,
    );
    final updated = (await container.read(orderDetailProvider('ord-0142').future))!;
    expect(updated.paid, 31500);
    expect(updated.paymentStatus, PayStatus.lunas);
    await container.read(antreanDataProvider.future);
    expect(
      await payments.record(detail, amount: 1000, method: PayMethod.tunai, received: 1000),
      isFalse,
    );
  });
}
