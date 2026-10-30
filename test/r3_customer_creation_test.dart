import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/transactions/pages/add_customer_sheet.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

import 'antrean_test_host.dart';
import 'keyboard_test_helper.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('Baru saves a customer, selects draft and keeps keyboard actions visible', (tester) async {
    configureKeyboardTest(tester);
    final host = await pumpAntrean(tester, location: '/transaksi/baru');
    await tester.tap(find.widgetWithText(AppButton, 'Baru'));
    await tester.pumpAndSettle();
    expect(tester.widget<AddCustomerSheet>(find.byType(AddCustomerSheet)).forOrder, isTrue);
    final fields = find.descendant(of: find.byType(AddCustomerSheet),
        matching: find.byType(TextField));
    await tester.enterText(fields.at(0), 'Pelanggan R3');
    await tester.enterText(fields.at(1), '081299998888');
    await expectKeyboardVisible(tester,
      field: find.descendant(of: find.byType(AddCustomerSheet),
          matching: find.byType(AppTextField)).last,
      save: find.widgetWithText(AppButton, 'Simpan pelanggan'),
    );
    await tester.tap(find.widgetWithText(AppButton, 'Simpan pelanggan'));
    await tester.pumpAndSettle();
    tester.view.viewInsets = const FakeViewPadding();
    await tester.pumpAndSettle();
    expect(find.byType(AddCustomerSheet), findsNothing);
    expect(host.container.read(transactionDraftProvider).customerId, isNotNull);
    expect(find.text('Pelanggan R3'), findsOneWidget);
    expect(find.widgetWithText(AppButton, 'Baru'), findsNothing);
  });
  testWidgets('closing direct add-customer leaves the draft unchanged', (tester) async {
    configureKeyboardTest(tester);
    final host = await pumpAntrean(tester, location: '/transaksi/baru');
    final before = host.container.read(transactionDraftProvider);
    await tester.tap(find.widgetWithText(AppButton, 'Baru'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Tutup'));
    await tester.pumpAndSettle();
    expect(host.container.read(transactionDraftProvider), same(before));
    expect(find.widgetWithText(AppButton, 'Baru'), findsOneWidget);
  });
}
