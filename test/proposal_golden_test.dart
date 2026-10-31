import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final (name, route) in [
    ('proposal_rina', '/antrean/usulan/prop-002'),
    ('proposal_new_customer', '/antrean/usulan/prop-003'),
    ('proposal_history', '/lainnya/ai/riwayat'),
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
    testWidgets('$name 320px 2x text no overflow', (tester) async {
      tester.view.physicalSize = const Size(320, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await pumpAntrean(tester, location: route, textScale: 2);
      expect(tester.takeException(), isNull);
    });
  }
}
