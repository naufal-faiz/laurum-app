import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/features/orders/state/order_detail_controller.dart';

import 'b1d_commands.dart';
import 'b1d_harness.dart';

void main() {
  late B1dHarness h;
  setUp(() async {
    h = B1dHarness();
    await h.seed();
  });
  tearDown(() => h.close());
  for (final mode in [true, false]) {
    test('COD cannot complete until paid through the real flow, mode=$mode', () async {
      await h.business.saveProfile((await h.business.getProfile()).withOrderStatus(enabled: mode));
      final id = (await checkout(h))!;
      var order = (await h.orders.getOrderById(id))!;
      if (mode) {
        expect(await h.scope.read(orderActionsProvider.notifier).advance(order), isTrue);
        order = (await h.orders.getOrderById(id))!;
        expect(await h.scope.read(orderActionsProvider.notifier).advance(order), isFalse);
      } else {
        await expectLater(h.scope.read(completionCommand)(order), throwsStateError);
      }
      await h.scope.read(paymentCommand)(id, 1000, complete: true);
      expect((await h.orders.getOrderById(id))!.status, OrderStatus.selesai);
      expect(await h.orders.getPaymentsByOrderId(id), hasLength(1));
    });
  }
  for (final table in ['orders', 'payments', 'order_events', 'savings_entries', 'outbox']) {
    test('payment and excess deposit roll back when $table fails', () async {
      final id = (await checkout(h))!;
      final before = await h.snapshot();
      await h.fail(table);
      await expectLater(
        h.scope.read(paymentCommand)(id, 1500, saveExcess: true),
        throwsA(anything),
      );
      expect(await h.snapshot(), before);
      await h.db.customStatement('DROP TRIGGER injected');
      await h.scope.read(paymentCommand)(id, 1500, saveExcess: true);
      expect(await h.savings.getBalance(h.customerId), 500);
      expect((await h.orders.getPaymentsByOrderId(id)).single.amount, 1000);
    });
  }
}
