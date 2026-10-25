import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/shared/widgets/molecules/notice_ai.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  testWidgets('settings menu shows groups, notice, version and logout dialog', (tester) async {
    final host = await pumpAntrean(tester, location: '/lainnya');
    expect(find.text('Layanan dan tarif'), findsOneWidget);
    expect(find.text('Pengeluaran'), findsOneWidget);
    expect(find.text('Printer dan struk'), findsOneWidget);
    expect(find.text('Otomatisasi AI'), findsOneWidget);
    expect(find.text('Info usaha & alamat'), findsOneWidget);
    expect(find.text('Sinkronisasi'), findsOneWidget);
    expect(find.text('Email Google & hapus akun'), findsOneWidget);
    expect(find.text('Keluar'), findsOneWidget);
    expect(find.text('Laurum v1.0.0'), findsOneWidget);
    expect(find.text(NoticeAi.message), findsOneWidget);

    await tester.ensureVisible(find.text('Keluar'));
    await tester.tap(find.text('Keluar'));
    await tester.pumpAndSettle();
    expect(find.text('Keluar dari akun?'), findsOneWidget);
    expect(
      find.text('Data tetap tersimpan online. Anda bisa masuk lagi kapan saja.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Kembali'));
    await tester.pumpAndSettle();
    expect(find.text('Keluar dari akun?'), findsNothing);

    await tester.tap(find.text('Keluar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keluar').last);
    await tester.pumpAndSettle();
    expect(host.container.read(authServiceProvider).isSignedIn, isFalse);
    expect(find.text('Masuk'), findsWidgets);
  });

  testWidgets('settings rows open service directory and business info', (tester) async {
    final host = await pumpAntrean(tester, location: '/lainnya');
    await tester.tap(find.text('Layanan dan tarif'));
    await tester.pumpAndSettle();
    expect(find.text('Daftar layanan'), findsOneWidget);

    host.router.go('/lainnya');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Info usaha & alamat'));
    await tester.tap(find.text('Info usaha & alamat'));
    await tester.pumpAndSettle();
    expect(find.text('Info usaha'), findsOneWidget);
  });

  testWidgets('settings tab fits 320 px with 2x text', (tester) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpAntrean(tester, location: '/lainnya', textScale: 2);
    expect(find.text('Layanan dan tarif'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
