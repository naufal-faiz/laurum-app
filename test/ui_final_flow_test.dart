import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/reports/state/report_view.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/shared/widgets/atoms/app_switch.dart';

import 'antrean_test_host.dart';
import 'ui_final_flow_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('acceptance: new customer, savings/cash receipt, ready/deliver and report', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final host = await pumpAntrean(tester, location: '/transaksi/baru', textScale: 1.3);
    final scope = host.container;
    final before = await scope.read(reportViewProvider.future);
    await uiFinalCreateCustomer(tester);
    final customerId = scope.read(transactionDraftProvider).customerId!;
    host.router.go('/pelanggan/$customerId');
    await tester.pumpAndSettle();
    await uiFinalDeposit(tester);
    expect(await scope.read(savingsRepositoryProvider).getBalance(customerId), 5000);
    host.router.go('/transaksi/baru');
    await tester.pumpAndSettle();
    await uiFinalSelectWeight(tester);
    expect(scope.read(transactionDraftProvider).total, 18000);
    await uiFinalTap(tester, 'Bayar');
    await tester.ensureVisible(find.byType(AppSwitch));
    await tester.tap(find.byType(AppSwitch));
    await tester.pumpAndSettle();
    expect(find.text('Tabungan dipakai -Rp5.000'), findsOneWidget);
    expect(find.text('Sisa bayar Rp13.000'), findsWidgets);
    await uiFinalTap(tester, 'Konfirmasi pembayaran');
    expect(find.text('Nota tersimpan'), findsOneWidget);
    final repo = scope.read(orderRepositoryProvider);
    final order = (await repo.getOrderByOrderNo('A-0143'))!;
    final payments = await repo.getPaymentsByOrderId(order.id);
    expect(payments.where((p) => p.method == PayMethod.tabungan).single.amount, 5000);
    expect(payments.where((p) => p.method == PayMethod.tunai).single.amount, 13000);
    expect(await scope.read(savingsRepositoryProvider).getBalance(customerId), 0);
    await uiFinalTap(tester, 'Ke beranda');
    expect(
      (await scope.read(antreanDataProvider.future)).orders.map((o) => o.id),
      contains(order.id),
    );
    await tester.scrollUntilVisible(
      find.byKey(ValueKey(order.id)),
      300,
      scrollable: find.byType(Scrollable).first,
      maxScrolls: 30,
    );
    await uiFinalTap(tester, order.orderNo);
    await uiFinalTap(tester, 'Tandai siap');
    expect((await repo.getOrderById(order.id))!.status, OrderStatus.siap);
    await uiFinalTap(tester, 'Serahkan');
    expect((await repo.getOrderById(order.id))!.status, OrderStatus.selesai);
    expect(
      (await scope.read(antreanDataProvider.future)).orders.map((o) => o.id),
      isNot(contains(order.id)),
    );
    host.router.go('/laporan');
    await tester.pumpAndSettle();
    final after = await scope.read(reportViewProvider.future);
    expect(after.totals.revenue, before.totals.revenue + 18000);
    expect(after.totals.transactionCount, before.totals.transactionCount + 1);
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Pendapatan ${Formatters.rupiah(after.totals.revenue)}'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
