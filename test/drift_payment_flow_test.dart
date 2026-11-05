import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/persistence/demo_fixture_id.dart';
import 'package:laurum/core/persistence/storage_providers.dart';
import 'package:laurum/features/expenses/state/expense_form_controller.dart';
import 'package:laurum/features/orders/state/order_detail_controller.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/orders/state/order_payment_controller.dart';
import 'package:laurum/features/reports/data/report_ranges.dart';
import 'package:laurum/features/shell/pages/app_router.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';

import 'drift_app_harness.dart';
import 'drift_widget_step.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('Drift: COD, partial, excess savings, cancellation and expense', (tester) async {
    final app = (await tester.runAsync(driftAppHarness))!;
    final c = app.container, s = app.store;
    final router = createAppRouter(container: c);
    addTearDown(() async {
      router.dispose();
      c.dispose();
      await s.dispose();
      await s.db.close();
    });
    await pumpDriftApp(tester, c, router);
    Future<T?> step<T>(Future<T> Function() action) => driftWidgetStep(tester, action);
    final customer = demoFixtureId(demoOwnerId, 'cust-001');
    final service = (await step(s.services.getServices))!
        .firstWhere((s) => s.name == 'Cuci setrika');
    final before = (await step(() => s.reports.getReport(weekRange)))!;
    c.read(transactionDraftProvider.notifier)
      ..selectCustomer(customer)
      ..add(service)
      ..setQuantity(service.id, 1000);
    c.read(checkoutControllerProvider.notifier).setTerm(PayTerm.cod);
    final id = (await step(c.read(checkoutControllerProvider.notifier).save))!;
    var detail = (await step<OrderDetailData?>(() => c.read(orderDetailProvider(id).future)))!;
    expect(detail.order.payTerm, PayTerm.cod);
    expect(detail.paid, 0);
    final actions = c.read(orderActionsProvider.notifier);
    expect(await step(() => actions.advance(detail.order)), isTrue);
    detail = (await step<OrderDetailData?>(() => c.read(orderDetailProvider(id).future)))!;
    expect(await step(() => actions.advance(detail.order)), isFalse);
    final payment = c.read(orderPaymentProvider.notifier);
    expect(
      await step(
        () => payment.record(detail, amount: 3000, method: PayMethod.tunai, received: 3000),
      ),
      isTrue,
    );
    detail = (await step<OrderDetailData?>(() => c.read(orderDetailProvider(id).future)))!;
    expect(detail.paid, 3000);
    final balance = (await step(() => s.savings.getBalance(customer)))!;
    expect(
      await step(
        () => payment.record(
          detail,
          amount: 6000,
          method: PayMethod.tunai,
          received: 10000,
          saveExcess: true,
        ),
      ),
      isTrue,
    );
    expect(await step(() => s.savings.getBalance(customer)), balance + 4000);
    detail = (await step<OrderDetailData?>(() => c.read(orderDetailProvider(id).future)))!;
    expect(detail.paymentStatus, PayStatus.lunas);
    expect(await step(() => actions.cancel(detail)), isTrue);
    expect((await step(() => s.reports.getReport(weekRange)))!.revenue, before.revenue);
    final form = c.read(expenseFormProvider.notifier);
    form.category((await step(s.expenses.getCategories))!.first.id);
    form.nominal('25000');
    form.note('Pengeluaran pengujian');
    expect(await step(form.save), isTrue);
    expect((await step(() => s.reports.getReport(weekRange)))!.expenses, before.expenses + 25000);
    await step(s.sync.refresh);
    expect(
      s.sync.pendingChanges,
      (await step(() => s.db.select(s.db.outboxRecords).get()))!.length,
    );
    router.go('/transaksi/nota/$id');
    await tester.pumpAndSettle();
    expect(find.textContaining('A-0143'), findsWidgets);
    router.go('/laporan');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
