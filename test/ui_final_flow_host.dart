import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/transactions/pages/add_customer_sheet.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/organisms/numpad.dart';

Future<void> uiFinalTap(WidgetTester tester, String text) async {
  expect(find.text(text), findsWidgets, reason: 'Aksi $text harus tersedia');
  final target = find.text(text).last;
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Future<void> uiFinalCreateCustomer(WidgetTester tester) async {
  await uiFinalTap(tester, 'Pelanggan baru');
  final fields = find.descendant(
    of: find.byType(AddCustomerSheet),
    matching: find.byType(EditableText),
  );
  await tester.enterText(fields.at(0), 'Pelanggan Uji Akhir');
  await tester.enterText(fields.at(1), '081299991234');
  await uiFinalTap(tester, 'Simpan pelanggan');
  expect(find.widgetWithText(AppButton, 'Pelanggan baru'), findsNothing);
}

Future<void> uiFinalDeposit(WidgetTester tester) async {
  await uiFinalTap(tester, 'Setor tabungan');
  for (final digit in ['5', '0', '0', '0']) {
    final key = find.descendant(of: find.byType(Numpad), matching: find.text(digit));
    await tester.ensureVisible(key);
    await tester.pumpAndSettle();
    await tester.tap(key);
    await tester.pump();
  }
  await uiFinalTap(tester, 'Simpan tabungan (Rp5.000)');
}

Future<void> uiFinalSelectWeight(WidgetTester tester) async {
  final choose = find.widgetWithText(AppButton, 'Pilih layanan');
  await tester.ensureVisible(choose);
  await tester.pumpAndSettle();
  expect(choose.hitTestable(), findsOneWidget);
  await tester.tap(choose);
  await tester.pumpAndSettle();
  await uiFinalTap(tester, 'Cuci setrika');
  await uiFinalTap(tester, 'Ubah berat');
  await uiFinalTap(tester, '1 kg');
  await uiFinalTap(tester, '2');
  await uiFinalTap(tester, 'Simpan berat');
  await uiFinalTap(tester, 'Selesai');
}
