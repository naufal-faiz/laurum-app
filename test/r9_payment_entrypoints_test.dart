import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/features/orders/state/order_detail_controller.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';

import 'antrean_test_host.dart';
import 'r9_checkout_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final path in ['receipt', 'outstanding', 'detail']) {
    testWidgets('completed partial non-COD can be paid from $path', (tester) async {
      final scope = r9Scope();
      var data = await r9Checkout(scope, useStatus: true, term: PayTerm.sekarang, received: 10000);
      await scope.read(orderActionsProvider.notifier).advance(data.order);
      data = (await scope.read(orderDetailProvider(data.order.id).future))!;
      await scope.read(orderActionsProvider.notifier).advance(data.order);
      final id = data.order.id;
      await pumpAntrean(
        tester,
        container: scope,
        location: switch (path) {
          'receipt' => '/transaksi/nota/$id',
          'outstanding' => '/laporan/piutang',
          _ => '/order/$id',
        },
      );
      final button = path == 'outstanding'
          ? find.text('Catat bayar').last
          : find.text('Catat pembayaran');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Simpan pembayaran'));
      await tester.pumpAndSettle();
      final updated = (await scope.read(orderDetailProvider(id).future))!;
      expect(updated.paid, 25000);
      expect(updated.order.status, OrderStatus.selesai);
      expect(tester.takeException(), isNull);
    });
  }
}
