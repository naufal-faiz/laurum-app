import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/id_generator_provider.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/orders/state/order_payment_controller.dart';
import 'package:laurum/features/reports/state/report_period.dart';
import 'package:laurum/features/reports/state/report_view.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/main_dummy.dart';

import 'fake_id_generator.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  test('week matches DATA MASTER and changing period never reuses weekly detail', () async {
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        idGeneratorProvider.overrideWithValue(FakeIdGenerator(newValues: ['ord-0143'])),
      ],
    );
    addTearDown(scope.dispose);
    final week = await scope.read(reportViewProvider.future);
    expect(week.totals.revenue, 589000);
    expect(week.totals.profit, -261000);
    expect(week.totals.cashIn, 500000);
    expect(week.totals.savingsBalance, 430000);
    expect(week.totals.activeOutstanding, 400500);
    expect(week.unpaidCount, 5);
    expect(week.daily, [0, 0, 248000, 164000, 177000, null, null]);
    expect(week.services!.map((s) => s.revenue), [301500, 108000, 100000, 59500, 20000]);
    scope.read(reportPeriodProvider.notifier).select(0);
    final today = await scope.read(reportViewProvider.future);
    expect(today.totals.revenue, 177000);
    expect(today.services!.map((s) => s.revenue), [67500, 59500, 50000]);
    scope.read(reportPeriodProvider.notifier).select(2);
    final month = await scope.read(reportViewProvider.future);
    expect(month.totals.revenue, 864000);
    expect(month.services!.map((s) => s.revenue), [375000, 301500, 108000, 59500, 20000]);
    expect(month.daily, isNull);
  });
  test('checkout updates today/week and daily bar; debt payment updates cash and count', () async {
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        idGeneratorProvider.overrideWithValue(FakeIdGenerator(newValues: ['ord-0143'])),
      ],
    );
    addTearDown(scope.dispose);
    await scope.read(reportViewProvider.future);
    final draft = scope.read(transactionDraftProvider.notifier)..selectCustomer('cust-001');
    draft.add(serviceFixtures.firstWhere((s) => s.id == 'srv-003'));
    draft.setQuantity('srv-003', 3500);
    draft.add(serviceFixtures.firstWhere((s) => s.id == 'srv-004'));
    final checkout = scope.read(checkoutControllerProvider.notifier);
    checkout.setSavings(value: true, due: 6500);

    checkout.setReceived(10000, due: 6500);
    expect(await checkout.save(), 'ord-0143');
    final week = await scope.read(reportViewProvider.future);
    expect(week.totals.revenue, 645500);
    expect(week.daily![4], 233500);
    scope.read(reportPeriodProvider.notifier).select(0);
    expect((await scope.read(reportViewProvider.future)).totals.revenue, 233500);
    final detail = (await scope.read(orderDetailProvider('ord-0142').future))!;
    expect(
      await scope
          .read(orderPaymentProvider.notifier)
          .record(detail, amount: 31500, method: PayMethod.tunai, received: 31500),
      isTrue,
    );
    final after = await scope.read(reportViewProvider.future);
    expect(after.unpaidCount, 4);
    expect(after.totals.activeOutstanding, 369000);
    expect(after.totals.cashIn, 168500);
  });
}
