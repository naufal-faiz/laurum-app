import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

import 'antrean_test_host.dart';
import 'keyboard_test_helper.dart';
import 'r10_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final entry in {
    '/masuk': ['Email', 'Password'],
    '/daftar': ['Nama', 'Email', 'Password', 'Konfirmasi password'],
    '/lupa-password': ['Email'],
  }.entries) {
    for (final label in entry.value) {
      testWidgets('${entry.key} $label and save above keyboard 300dp', (tester) async {
        configureKeyboardTest(tester, size: const Size(320, 844));
        await pumpAntrean(tester, container: r10Scope(), location: entry.key);
        final save = switch (entry.key) {
          '/masuk' => 'Masuk',
          '/daftar' => 'Daftar',
          _ => 'Kirim tautan reset',
        };
        await expectKeyboardVisible(
          tester,
          field: authField(label),
          save: find.widgetWithText(AppButton, save),
        );
      });
    }
  }
}
