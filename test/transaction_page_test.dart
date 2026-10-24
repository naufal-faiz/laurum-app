import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/orders/pages/antrean_controller.dart';
import 'package:laurum/features/transactions/pages/customer_picker_sheet.dart';
import 'package:laurum/features/transactions/pages/discount_sheet.dart';
import 'package:laurum/features/transactions/pages/transaction_draft.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_numpad_key.dart';
import 'package:laurum/shared/widgets/molecules/stepper_field.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  testWidgets('transaction flow selects customer, service, weight and discount', (tester) async {
    final host = await pumpAntrean(tester, location: '/transaksi/baru');
    await tester.tap(find.text('Pilih pelanggan'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(of: find.byType(CustomerPickerSheet), matching: find.byType(TextField)),
      'Dedi',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pak Dedi Budiarto'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Saldo Rp50.000'), findsOneWidget);

    await tester.tap(find.widgetWithText(AppButton, 'Pilih layanan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cuci setrika').first);
    await tester.pumpAndSettle();
    expect(host.container.read(transactionDraftProvider).itemCount, 1);
    expect(host.router.routeInformationProvider.value.uri.path, '/transaksi/baru');
    expect(find.text('1 kg · Rp9.000'), findsOneWidget);

    await tester.tap(find.text('1 kg · Rp9.000'));
    await tester.pumpAndSettle();
    final plus = find.descendant(of: find.byType(StepperField), matching: find.text('+'));
    await tester.tap(plus);
    await tester.pump();
    await tester.tap(plus);
    await tester.pumpAndSettle();
    final value = find.descendant(of: find.byType(StepperField), matching: find.text('2 kg'));
    await tester.tap(value);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(AppNumpadKey).last);
    await tester.tap(find.text('3'));
    await tester.tap(find.text('Simpan berat'));
    await tester.pumpAndSettle();
    expect(host.container.read(transactionDraftProvider).lines.single.qtyMilli, 3000);
    await tester.tap(find.text('Selesai'));
    await tester.pumpAndSettle();
    expect(find.text('3 kg · Rp27.000'), findsOneWidget);
    expect(host.container.read(transactionDraftProvider).discount, 0);

    await tester.ensureVisible(find.text('Atur diskon'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Atur diskon'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(of: find.byType(DiscountSheet), matching: find.byType(TextField)),
      '1000',
    );
    await tester.tap(find.text('Simpan diskon'));
    await tester.pumpAndSettle();
    expect(host.container.read(transactionDraftProvider).total, 26000);
    expect(find.text('Total tagihan (1 item)'), findsOneWidget);
    await tester.tap(find.text('Bayar'));
    await tester.pumpAndSettle();
    expect(find.text('Pembayaran'), findsWidgets);
  });

  testWidgets('leaving a filled draft asks for confirmation and clears it', (tester) async {
    final host = await pumpAntrean(tester, location: '/transaksi/baru');
    host.container.read(transactionDraftProvider.notifier).selectCustomer('cust-001');
    await tester.pump();
    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    expect(find.text('Keluar tanpa menyimpan?'), findsOneWidget);
    await tester.tap(find.text('Keluar tanpa simpan'));
    await tester.pumpAndSettle();
    expect(host.router.routeInformationProvider.value.uri.path, '/antrean');
    expect(host.container.read(transactionDraftProvider).isEmpty, isTrue);
    expect(host.container.read(antreanFilterProvider), 0);
  });

  testWidgets('empty draft opens without confirmation and Bayar is disabled', (tester) async {
    final host = await pumpAntrean(tester, location: '/transaksi/baru');
    expect(tester.widget<TextButton>(find.widgetWithText(TextButton, 'Bayar')).onPressed, isNull);
    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    expect(find.text('Keluar tanpa menyimpan?'), findsNothing);
    expect(host.router.routeInformationProvider.value.uri.path, '/antrean');
  });
}
