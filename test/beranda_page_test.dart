import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/shared/widgets/organisms/bottom_nav_bar.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('Beranda renders the dashboard and matches the frame golden', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpAntrean(tester, location: '/beranda');
    expect(find.text('LAURUM'), findsOneWidget);
    expect(find.text('Selamat datang kembali,'), findsOneWidget);
    expect(find.text('Antrean aktif'), findsOneWidget);
    expect(find.text('Pelanggan tersimpan'), findsOneWidget);
    expect(find.text('Pendapatan minggu ini'), findsOneWidget);
    expect(find.text('Pelanggan paling sering'), findsOneWidget);
    expect(tester.widget<BottomNavBar>(find.byType(BottomNavBar)).activeIndex, 0);
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byKey(const ValueKey('antrean-golden')),
      matchesGoldenFile('goldens/beranda.png'),
    );
  });

  testWidgets('nav opens Beranda and fits 320 px at double text', (tester) async {
    tester.view.physicalSize = const Size(320, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final host = await pumpAntrean(tester, textScale: 2);
    await tester.tap(
      find.descendant(of: find.byType(BottomNavBar), matching: find.text('Beranda')),
    );
    await tester.pumpAndSettle();
    expect(host.router.routeInformationProvider.value.uri.path, '/beranda');
    expect(find.text('Antrean aktif'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
