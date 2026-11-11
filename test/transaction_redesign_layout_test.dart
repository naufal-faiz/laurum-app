import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final filled in [false, true]) {
    testWidgets('transaction redesign 320dp 2x filled=$filled', (tester) async {
      tester.view.physicalSize = const Size(320, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final host = await pumpAntrean(tester, location: '/transaksi/baru', textScale: 2);
      if (filled) {
        host.container.read(transactionDraftProvider.notifier)
          ..selectCustomer('cust-001')
          ..add(serviceFixtures.first);
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.textContaining('Ubah berat').first);
      }
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('transaction empty golden', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpAntrean(tester, location: '/transaksi/baru');
    await expectLater(
      find.byKey(const ValueKey('antrean-golden')),
      matchesGoldenFile('goldens/transaction_empty.png'),
    );
  });
}
