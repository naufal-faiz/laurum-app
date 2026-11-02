import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/auth/pages/change_password_sheet.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';

import 'antrean_test_host.dart';
import 'r10_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('settings only links Manage; Google account profile edits and password hint', (
    tester,
  ) async {
    final scope = r10Scope(signedIn: true);
    await pumpAntrean(tester, container: scope, location: '/lainnya');
    expect(find.text('Hapus akun'), findsNothing);
    await tapAuthText(tester, 'Kelola akun');
    expect(find.text('ratna@example.com'), findsOneWidget);
    expect(find.text('Ganti email belum tersedia'), findsOneWidget);
    expect(find.text('Akun Google'), findsOneWidget);
    expect(find.text('Tertaut'), findsOneWidget);
    expect(find.widgetWithText(MenuRow, 'Ganti password'), findsNothing);
    expect(find.byType(TextField), findsNothing);
    await tapAuthText(tester, 'Nama');
    await fillAuthField(tester, 'Nama', '');
    await tapAuthButton(tester, 'Simpan profil');
    expect(find.text('Nama wajib diisi.'), findsOneWidget);
    await fillAuthField(tester, 'Nama', 'Ratna Baru');
    await tapAuthButton(tester, 'Simpan profil');
    expect(scope.read(authServiceProvider).name, 'Ratna Baru');
    expect(find.text('Ratna Baru'), findsOneWidget);
    await tapAuthText(tester, 'No. telp');
    await fillAuthField(tester, 'No. telp', '+62 812-3456-7890');
    await tapAuthButton(tester, 'Simpan profil');
    expect(scope.read(authServiceProvider).phone, '+6281234567890');
    expect(find.text('0812-3456-7890'), findsOneWidget);
    expect(find.byType(ChangePasswordSheet), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets('email user changes password, signs out and logs in using new password', (
    tester,
  ) async {
    final scope = await r10PasswordScope();
    await pumpAntrean(tester, container: scope, location: '/lainnya/akun');
    await tapAuthText(tester, 'Ganti password');
    await fillAuthField(tester, 'Password lama', 'wrong');
    await fillAuthField(tester, 'Password baru', 'NewPass123!');
    await fillAuthField(tester, 'Konfirmasi password', 'NewPass123!');
    await tapAuthButton(tester, 'Simpan password');
    expect(find.textContaining('Password lama tidak cocok'), findsWidgets);
    await fillAuthField(tester, 'Password lama', 'Laundry123!');
    await tapAuthButton(tester, 'Simpan password');
    expect(find.byType(ChangePasswordSheet), findsNothing);
    await tapAuthButton(tester, 'Keluar');
    await tapAuthButton(tester, 'Keluar');
    await fillAuthField(tester, 'Email', 'ratna@example.com');
    await fillAuthField(tester, 'Password', 'NewPass123!');
    await tapAuthButton(tester, 'Masuk');
    expect(find.text('Antrean aktif'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
