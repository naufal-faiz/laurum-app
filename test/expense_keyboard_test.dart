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
  for (final label in ['Jumlah pengeluaran', 'Vendor / toko', 'Catatan / rincian keperluan']) {
    testWidgets('$label and save visible above 300dp keyboard', (tester) async {
      configureKeyboardTest(tester, size: const Size(320, 844));
      final host = await pumpAntrean(tester, location: '/lainnya/pengeluaran/baru');
      host.container.read(expenseFormProvider.notifier).category('cat-001');
      host.container.read(expenseFormProvider.notifier).nominal('5000');
      await tester.pumpAndSettle();
      final field = find.descendant(
        of: find.byWidgetPredicate((w) => w is AppTextField && w.label == label),
        matching: find.byType(TextField),
      );
      await expectKeyboardVisible(
        tester,
        field: field,
        save: find.widgetWithText(AppButton, 'Simpan pengeluaran'),
      );
    });
  }
  testWidgets('new category keyboard, validation and selection', (tester) async {
    configureKeyboardTest(tester);
    final host = await pumpAntrean(tester, location: '/lainnya/pengeluaran/baru');
    final button = find.text('Kategori baru');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan kategori'));
    await tester.pumpAndSettle();
    expect(find.text('Nama kategori wajib diisi.'), findsOneWidget);
    final field = find.descendant(
      of: find.byWidgetPredicate((w) => w is AppTextField && w.label == 'Nama kategori'),
      matching: find.byType(TextField),
    );
    await expectKeyboardVisible(
      tester,
      field: field,
      save: find.widgetWithText(AppButton, 'Simpan kategori'),
    );
    await tester.enterText(field, 'Perawatan mesin');
    await tester.tap(find.text('Simpan kategori'));
    await tester.pumpAndSettle();
    expect(host.container.read(expenseFormProvider).categoryId, startsWith('cat-'));
    expect(find.text('Perawatan mesin'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
