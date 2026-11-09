import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ionicons/ionicons.dart';
import 'package:laurum/core/services/service_providers.dart';

import 'antrean_test_host.dart';
import 'r10_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('register -> check email -> onboarding -> queue; passwords hidden by default', (
    tester,
  ) async {
    final scope = r10Scope();
    final host = await pumpAntrean(tester, container: scope, location: '/daftar');
    await fillAuthField(tester, 'Nama', 'Nama Baru');
    await fillAuthField(tester, 'Email', 'new@example.com');
    await fillAuthField(tester, 'Password', 'NewPass123!');
    await fillAuthField(tester, 'Konfirmasi password', 'NewPass123!');
    expect(tester.widget<TextField>(authField('Password')).obscureText, isTrue);
    await tester.tap(find.byIcon(Ionicons.eyeOutline).first);
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(authField('Password')).obscureText, isFalse);
    expect(tester.widget<TextField>(authField('Password')).controller!.text, 'NewPass123!');
    await tester.tap(find.byIcon(Ionicons.eyeOffOutline).first);
    await tester.pumpAndSettle();
    await tapAuthButton(tester, 'Daftar');
    expect(host.router.routeInformationProvider.value.uri.path, '/cek-email');
    expect(scope.read(authServiceProvider).isSignedIn, isFalse);
    await tapAuthButton(tester, 'Lanjut');
    expect(host.router.routeInformationProvider.value.uri.path, '/lainnya/info-usaha');
    await fillAuthField(tester, 'Nama usaha', 'Laundry Baru');
    await tapAuthButton(tester, 'Simpan');
    expect(find.text('Antrean aktif'), findsOneWidget);
    expect(scope.read(authServiceProvider).name, 'Nama Baru');
    expect(tester.takeException(), isNull);
  });
  testWidgets('duplicate gets check-email message but cannot confirm into existing account', (
    tester,
  ) async {
    final scope = r10Scope();
    final host = await pumpAntrean(tester, container: scope, location: '/daftar');
    await fillAuthField(tester, 'Nama', 'Different');
    await fillAuthField(tester, 'Email', 'ratna@example.com');
    await fillAuthField(tester, 'Password', 'OtherPass123!');
    await fillAuthField(tester, 'Konfirmasi password', 'OtherPass123!');
    await tapAuthButton(tester, 'Daftar');
    expect(
      find.text('Periksa kotak masuk dan folder spam untuk melanjutkan pendaftaran.'),
      findsOneWidget,
    );
    expect(find.textContaining('sudah terdaftar'), findsNothing);
    await tapAuthButton(tester, 'Lanjut');
    expect(host.router.routeInformationProvider.value.uri.path, '/cek-email');
    expect(scope.read(authServiceProvider).isSignedIn, isFalse);
  });
}
