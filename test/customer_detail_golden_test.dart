import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'customer_detail_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final scale in [1.0, 2.0]) {
    testWidgets('customer detail golden with actual text scale $scale', (tester) async {
      await pumpUnscaledCustomerDetail(tester, width: scale == 1 ? 390 : 320, scale: scale);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('customer-detail-golden')),
        matchesGoldenFile('goldens/customer_detail_${scale == 1 ? 'normal' : 'large_text'}.png'),
      );
    });
  }
}
