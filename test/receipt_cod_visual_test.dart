import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'antrean_test_host.dart';
import 'r9_checkout_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final scale in [1.0, 2.0]) {
    testWidgets('COD receipt actions scale $scale', (tester) async {
      tester.view.physicalSize = Size(scale == 1 ? 390 : 320, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final scope = r9Scope();
      final data = await r9Checkout(scope);
      await pumpAntrean(
        tester,
        container: scope,
        location: '/transaksi/nota/${data.order.id}',
        textScale: scale,
      );
      await tester.ensureVisible(find.text('Catat pembayaran'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Catat pembayaran').hitTestable(), findsOneWidget);
      expect(find.text('Selesai').hitTestable(), findsOneWidget);
      await expectLater(
        find.byKey(const ValueKey('antrean-golden')),
        matchesGoldenFile('goldens/receipt_cod_actions_${scale.toInt()}x.png'),
      );
    });
  }
}
