import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/domain/receipt_formatter.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/business/data/business_fixtures.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/reports/data/report_fixtures.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/main_dummy.dart';

import 'receipt_fixtures.dart';
import 'receipt_template_lines.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  test('checkout saves A-0143 atomically with savings and cash', () async {
    final container = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(container.dispose);
    final draft = container.read(transactionDraftProvider.notifier);
    draft.selectCustomer('cust-001');
    draft.add(serviceFixtures.firstWhere((s) => s.id == 'srv-003'));
    draft.setQuantity('srv-003', 3500);
    draft.add(serviceFixtures.firstWhere((s) => s.id == 'srv-004'));
    draft.setNote('pewangi lavender, jangan dicampur pakaian putih');
    final before = await container.read(reportRepositoryProvider).getReport(weekRange);

    final checkout = container.read(checkoutControllerProvider.notifier);
    checkout.setSavings(value: true, due: 6500);
    checkout.setMode(PaymentMode.lunas, due: 6500);
    checkout.setReceived(10000, due: 6500);
    final orderId = await checkout.save();
    expect(orderId, 'ord-0143');
    final id = orderId!;
    final orders = container.read(orderRepositoryProvider);
    final order = (await orders.getOrderByOrderNo('A-0143'))!;
    expect(order.id, id);
    expect(order.total, 56500);
    expect(order.status, OrderStatus.diproses);
    final items = await orders.getItemsByOrderId(id);
    expect(items, hasLength(2));
    expect(items.fold(0, (sum, item) => sum + item.lineTotal), 56500);
    final payments = await orders.getPaymentsByOrderId(id);
    expect(paidAmount(payments, orderId: id), 56500);
    expect(payments.singleWhere((p) => p.method == PayMethod.tunai).amount, 6500);
    expect(payments.singleWhere((p) => p.method == PayMethod.tunai).received, 10000);
    expect(await container.read(savingsRepositoryProvider).getBalance('cust-001'), 0);

    final after = await container.read(reportRepositoryProvider).getReport(weekRange);
    expect(after.revenue - before.revenue, 56500);
    final queue = await container.read(antreanDataProvider.future);
    expect(queue.orders.where((o) => o.id == orderId), hasLength(1));
    expect(container.read(transactionDraftProvider).isEmpty, isTrue);

    final lines = receiptLines(
      business: businessProfileFixture,
      order: order,
      items: items,
      payments: payments,
      customerName: 'Pak Dedi Budiarto',
      settings: receiptSettingsFixture,
    );
    expect(lines, contains('TOTAL                   Rp56.500'));
    expect(lines, contains('STATUS: LUNAS'));
    expect(lines, contains('Dibayar tunai            Rp6.500'));
    expect(
      receiptLines(
        business: receiptBusiness(),
        order: order,
        items: items,
        payments: payments,
        customerName: 'Pak Dedi',
        settings: receiptSettings(),
      ),
      receiptTemplateLines,
    );
  });
}
