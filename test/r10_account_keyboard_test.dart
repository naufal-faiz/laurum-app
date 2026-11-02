import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

import 'antrean_test_host.dart';
import 'keyboard_test_helper.dart';
import 'r10_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final label in [
    'Nama',
    'No. telp',
    'Password lama',
    'Password baru',
    'Konfirmasi password',
  ]) {
    testWidgets('account $label and save above keyboard 300dp', (tester) async {
      configureKeyboardTest(tester, size: const Size(320, 844));
      final scope = await r10PasswordScope();
      await pumpAntrean(tester, container: scope, location: '/lainnya/akun');
      final password = label.contains('assword');
      await tapAuthText(tester, password ? 'Ganti password' : label);
      await expectKeyboardVisible(
        tester,
        field: authField(label),
        save: find.widgetWithText(AppButton, password ? 'Simpan password' : 'Simpan profil'),
      );
    });
  }
}
