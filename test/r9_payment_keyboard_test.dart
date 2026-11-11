import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/orders/pages/payment_record_sheet.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/pages/cash_input_sheet.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

import 'antrean_test_host.dart';
import 'keyboard_test_helper.dart';
import 'r9_checkout_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('payment page and cash input save remain visible with 300dp keyboard', (
    tester,
  ) async {
    configureKeyboardTest(tester, size: const Size(320, 844));
    final scope = r9Scope();
    scope.read(transactionDraftProvider.notifier)
      ..selectCustomer('cust-001')
      ..add(serviceFixtures.firstWhere((s) => s.id == 'srv-004'));
    await pumpAntrean(tester, container: scope, location: '/transaksi/baru/bayar');
    final confirm = find.widgetWithText(AppButton, 'Konfirmasi pembayaran');
    final back = find.widgetWithText(AppButton, 'Kembali');
    expect(tester.getRect(back).center.dy, tester.getRect(confirm).center.dy);
    expect(tester.getRect(back).right, lessThan(tester.getRect(confirm).left));
    tester.view.viewInsets = const FakeViewPadding(bottom: 600);
    await tester.pumpAndSettle();
    final pageSave = find.widgetWithText(AppButton, 'Kembali');
    expect(tester.getRect(pageSave).bottom, lessThanOrEqualTo(544));
    expect(tester.getRect(confirm).bottom, lessThanOrEqualTo(544));
    await tester.ensureVisible(find.text('Uang diterima'));
    await tester.tap(find.text('Uang diterima'));
    await tester.pumpAndSettle();
    final sheet = find.byType(CashInputSheet);
    final amount = find.descendant(of: sheet, matching: find.text('Rp25.000')).first;
    expect(tester.getRect(amount).top, greaterThanOrEqualTo(0));
    expect(tester.getRect(amount).bottom, lessThanOrEqualTo(544));
    expect(
      tester.getRect(find.widgetWithText(AppButton, 'Simpan uang diterima')).bottom,
      lessThanOrEqualTo(544),
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets('record payment amount and save stay visible above 300dp keyboard', (tester) async {
    configureKeyboardTest(tester, size: const Size(320, 844));
    final scope = r9Scope();
    final data = await r9Checkout(scope);
    await pumpAntrean(tester, container: scope, location: '/order/${data.order.id}');
    await tester.tap(find.text('Terima pembayaran'));
    await tester.pumpAndSettle();
    tester.view.viewInsets = const FakeViewPadding(bottom: 600);
    await tester.pumpAndSettle();
    final sheet = find.byType(PaymentRecordSheet);
    final amount = find.descendant(of: sheet, matching: find.text('Rp25.000')).first;
    expect(tester.getRect(amount).bottom, lessThanOrEqualTo(544));
    expect(
      tester.getRect(find.widgetWithText(AppButton, 'Simpan pembayaran')).bottom,
      lessThanOrEqualTo(544),
    );
    expect(tester.takeException(), isNull);
  });
}
