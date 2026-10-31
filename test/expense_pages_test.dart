import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/expenses/state/expense_form_controller.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/organisms/expense_row.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('directory filters, opens detail and cancels then confirms deletion', (tester) async {
    final host = await pumpAntrean(tester, location: '/lainnya/pengeluaran');
    expect(find.text('Rp1.850.000'), findsOneWidget);
    expect(find.text('18 transaksi'), findsOneWidget);
    expect(find.text('Ekspor'), findsNothing);
    final chips = find.descendant(of: find.byType(ChipBar), matching: find.text('Bahan cuci'));
    await tester.tap(chips);
    await tester.pumpAndSettle();
    final entry = find.byWidgetPredicate((w) => w is ExpenseRow && w.amount == 110000);
    await tester.scrollUntilVisible(entry, 150, scrollable: find.byType(Scrollable).first);
    await tester.tap(entry);
    await tester.pumpAndSettle();
    expect(find.text('Detail pengeluaran'), findsOneWidget);
    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();
    expect(find.text('Hapus pengeluaran ini?'), findsOneWidget);
    await tester.tap(find.text('Kembali'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus').last);
    await tester.pumpAndSettle();
    tester.state<ScrollableState>(find.byType(Scrollable).first).position.jumpTo(0);
    await tester.pumpAndSettle();
    expect(find.text('17 transaksi'), findsOneWidget);
    await tester.tap(find.text('Catat pengeluaran'));
    await tester.pumpAndSettle();
    expect(find.text('Nominal harus lebih dari Rp0'), findsOneWidget);
    expect(
      tester.widget<AppButton>(find.widgetWithText(AppButton, 'Simpan pengeluaran')).onPressed,
      isNull,
    );
    final form = host.container.read(expenseFormProvider.notifier);
    form.nominal('5000');
    form.category('cat-001');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan pengeluaran'));
    await tester.pumpAndSettle();
    expect(find.text('18 transaksi'), findsOneWidget);
  });
  testWidgets('form 320px 2x allows category, date, vendor and note', (tester) async {
    tester.view.physicalSize = const Size(320, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpAntrean(tester, location: '/lainnya/pengeluaran/baru', textScale: 2);
    expect(tester.takeException(), isNull);
    final vendor = find.byWidgetPredicate((w) => w is AppTextField && w.label == 'Vendor / toko');
    await tester.ensureVisible(vendor);
    await tester.enterText(find.descendant(of: vendor, matching: find.byType(TextField)), 'Toko');
    expect(tester.takeException(), isNull);
  });
}
