import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'antrean_test_host.dart';
import 'report_redesign_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('report reference viewport390x844 golden', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpAntrean(tester, location: '/laporan');
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byKey(const ValueKey('antrean-golden')),
      matchesGoldenFile('goldens/report_redesign.png'),
    );
  });
  testWidgets('report direct2x font golden', (tester) async {
    await pumpReportUnscaled(tester, width: 320, scale: 2);
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byKey(const ValueKey('report-unscaled-golden')),
      matchesGoldenFile('goldens/report_redesign_large_text.png'),
    );
  });
}
