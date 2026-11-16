import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/expenses/state/expense_form_controller.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

import 'antrean_test_host.dart';
import 'keyboard_test_helper.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('expense form keeps vendor field and save above the keyboard', (tester) async {
    configureKeyboardTest(tester);
    final host = await pumpAntrean(tester, location: '/lainnya/pengeluaran/baru');
    host.container.read(expenseFormProvider.notifier).nominal('5000');
    host.container.read(expenseFormProvider.notifier).category('cat-001');
    await tester.pumpAndSettle();
    final vendor = find.byWidgetPredicate((w) => w is AppTextField && w.label == 'Vendor / toko');
    await expectKeyboardVisible(
      tester,
      field: find.descendant(of: vendor, matching: find.byType(TextField)),
      save: find.widgetWithText(AppButton, 'Simpan pengeluaran'),
    );
  });
}
