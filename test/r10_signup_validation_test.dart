import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ionicons/ionicons.dart';

import 'antrean_test_host.dart';
import 'r10_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('registration errors are inline and minimum password is enforced', (tester) async {
    await pumpAntrean(tester, container: r10Scope(), location: '/daftar');
    await tapAuthButton(tester, 'Daftar');
    expect(find.text('Nama wajib diisi.'), findsOneWidget);
    expect(find.text('Masukkan email yang valid.'), findsOneWidget);
    expect(find.text('Password minimal 8 karakter.'), findsOneWidget);
    await fillAuthField(tester, 'Nama', 'Nama Baru');
    await fillAuthField(tester, 'Email', 'new@example.com');
    await fillAuthField(tester, 'Password', '1234567');
    await fillAuthField(tester, 'Konfirmasi password', 'different');
    await tapAuthButton(tester, 'Daftar');
    expect(find.text('Password minimal 8 karakter.'), findsOneWidget);
    expect(find.text('Konfirmasi password tidak cocok.'), findsOneWidget);
  });
  testWidgets('leaving a password form discards secret fields and visibility', (tester) async {
    final host = await pumpAntrean(tester, container: r10Scope(), location: '/daftar');
    await fillAuthField(tester, 'Password', 'Temporary123!');
    await tester.tap(find.byIcon(Ionicons.eyeOutline).first);
    await tester.pumpAndSettle();
    host.router.go('/masuk');
    await tester.pumpAndSettle();
    host.router.go('/daftar');
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(authField('Password')).controller!.text, '');
    expect(tester.widget<TextField>(authField('Password')).obscureText, isTrue);
  });
}
