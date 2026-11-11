import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

import 'antrean_test_host.dart';
import 'keyboard_test_helper.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final (id, label) in [
    ('prop-003', 'Nama pelanggan'),
    ('prop-003', 'Nomor WhatsApp'),
    ('prop-003', 'Alamat penjemputan'),
    ('prop-002', 'Alamat penjemputan'),
  ]) {
    testWidgets('$id $label visible above keyboard with approve button', (tester) async {
      configureKeyboardTest(tester, size: const Size(320, 844));
      await pumpAntrean(tester, location: '/antrean/usulan/$id');
      final field = find.descendant(
        of: find.byWidgetPredicate((w) => w is AppTextField && w.label == label),
        matching: find.byType(TextField),
      );
      await expectKeyboardVisible(
        tester,
        field: field,
        save: find.widgetWithText(AppButton, 'Setujui jadi order'),
      );
    });
  }
  testWidgets('sheet Isi berat visible above keyboard with save', (tester) async {
    configureKeyboardTest(tester, size: const Size(320, 844));
    await pumpAntrean(tester, location: '/antrean/usulan/prop-002');
    await tester.ensureVisible(find.text('Isi berat'));
    await tester.tap(find.text('Isi berat'));
    await tester.pumpAndSettle();
    final field = find.descendant(
      of: find.byWidgetPredicate((w) => w is AppTextField && w.label == 'Berat'),
      matching: find.byType(TextField),
    );
    await expectKeyboardVisible(
      tester,
      field: field,
      save: find.widgetWithText(AppButton, 'Simpan'),
    );
  });
}
