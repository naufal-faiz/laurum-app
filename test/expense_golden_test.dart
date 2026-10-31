import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final (name, route) in [
    ('expense_directory', '/lainnya/pengeluaran'),
    ('expense_form', '/lainnya/pengeluaran/baru'),
  ]) {
    testWidgets('$name golden', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await pumpAntrean(tester, location: route);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('antrean-golden')),
        matchesGoldenFile('goldens/$name.png'),
      );
    });
  }
  testWidgets('expense directory 320px 2x text keeps fixed CTA and navigation', (tester) async {
    tester.view.physicalSize = const Size(320, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpAntrean(tester, location: '/lainnya/pengeluaran', textScale: 2);
    expect(tester.takeException(), isNull);
    expect(find.text('Catat pengeluaran').hitTestable(), findsOneWidget);
    await tester.tap(find.text('Lainnya'));
    await tester.pumpAndSettle();
    expect(find.text('PENGATURAN'), findsOneWidget);
  });
}
