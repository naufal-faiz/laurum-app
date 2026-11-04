import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/savings_entry.dart';
import 'package:laurum/features/orders/state/order_detail_controller.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/orders/state/order_edit_controller.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';

import 'b1d_commands.dart';
import 'b1d_harness.dart';

void main() {
  late B1dHarness h;
  setUp(() async {
    h = B1dHarness();
    await h.seed();
  });
  tearDown(() => h.close());
  for (final table in ['orders', 'order_items', 'order_events', 'outbox']) {
    test('edit snapshot rolls back on $table then retries', () async {
      final id = (await checkout(h))!;
      final subscription = h.scope.listen(orderEditProvider(id), (_, _) {});
      addTearDown(subscription.close);
      await h.scope.read(orderEditProvider(id).future);
      h.scope.read(transactionDraftProvider.notifier).setQuantity(h.serviceId, 2000);
      final before = await h.snapshot();
      await h.fail(table);
      expect(await h.scope.read(orderEditProvider(id).notifier).save(), isFalse);
      expect(await h.snapshot(), before);
      await h.db.customStatement('DROP TRIGGER injected');
      expect(await h.scope.read(orderEditProvider(id).notifier).save(), isTrue);
      expect((await h.orders.getOrderById(id))!.total, 2000);
      expect((await h.orders.getItemsByOrderId(id)).single.qtyMilli, 2000);
    });
  }
  for (final table in ['orders', 'payments', 'order_events', 'savings_entries', 'outbox']) {
    test('cancellation refunds savings atomically on $table failure', () async {
      await h.savings.addEntry(
        SavingsEntry(
          id: h.ids.newId(),
          ownerId: h.owner,
          createdAt: h.at,
          customerId: h.customerId,
          kind: SavingsKind.setor,
          amount: 1000,
          method: PayMethod.tunai,
        ),
      );
      final id = (await checkout(h, term: PayTerm.sekarang, savings: true))!;
      final data = (await h.scope.read(orderDetailProvider(id).future))!;
      final before = await h.snapshot();
      await h.fail(table);
      expect(await h.scope.read(orderActionsProvider.notifier).cancel(data), isFalse);
      expect(await h.snapshot(), before);
      await h.db.customStatement('DROP TRIGGER injected');
      expect(await h.scope.read(orderActionsProvider.notifier).cancel(data), isTrue);
      expect((await h.orders.getOrderById(id))!.status, OrderStatus.dibatalkan);
      expect(await h.savings.getBalance(h.customerId), 1000);
      expect((await h.orders.getPaymentsByOrderId(id)).fold<int>(0, (n, p) => n + p.amount), 0);
    });
  }
}
