import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';

import 'antrean_test_host.dart';
import 'r9_checkout_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final target in ['payment', 'detail', 'queue', 'outstanding']) {
    testWidgets('COD $target at 320 px and text 2x', (tester) async {
      tester.view.physicalSize = const Size(320, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final scope = r9Scope();
      String path;
      if (target == 'payment') {
        scope.read(checkoutControllerProvider.notifier).setTerm(PayTerm.cod);
        scope.read(transactionDraftProvider.notifier)
          ..selectCustomer('cust-001')
          ..add(serviceFixtures.firstWhere((s) => s.id == 'srv-004'));
        path = '/transaksi/baru/bayar';
      } else {
        final data = await r9Checkout(scope);
        path = switch (target) {
          'detail' => '/order/${data.order.id}',
          'queue' => '/antrean',
          _ => '/laporan/piutang',
        };
      }
      await pumpAntrean(tester, container: scope, location: path, textScale: 2);
      if (target == 'queue') {
        await tester.scrollUntilVisible(
          find.byKey(const ValueKey('ord-0143')),
          400,
          scrollable: find.byType(Scrollable).first,
          maxScrolls: 30,
        );
        await tester.pumpAndSettle();
      }
      if (target == 'outstanding') {
        await tester.tap(find.text('COD 1'));
        await tester.pumpAndSettle();
      }
      if (target == 'detail') {
        expect(tester.getSize(find.text('A-0143')).height, lessThan(80));
      }
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('antrean-golden')),
        matchesGoldenFile('goldens/r9_cod_$target.png'),
      );
    });
  }
}
