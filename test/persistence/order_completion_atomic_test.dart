import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';

import 'b1d_commands.dart';
import 'b1d_harness.dart';

void main() {
  for (final table in ['orders', 'order_events', 'outbox']) {
    test('simple completion restores status, event and outbox on $table failure', () async {
      final h = B1dHarness();
      addTearDown(h.close);
      await h.seed();
      await h.business.saveProfile((await h.business.getProfile()).withOrderStatus(enabled: false));
      final id = (await checkout(h, term: PayTerm.sekarang, received: 1000))!;
      final order = (await h.orders.getOrderById(id))!;
      final before = await h.snapshot();
      await h.fail(table);
      await expectLater(h.scope.read(completionCommand)(order), throwsA(anything));
      expect(await h.snapshot(), before);
      await h.db.customStatement('DROP TRIGGER injected');
      await h.scope.read(completionCommand)(order);
      expect((await h.orders.getOrderById(id))!.status, OrderStatus.selesai);
    });
  }
}
