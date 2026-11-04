import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/savings_entry.dart';

import 'b1d_commands.dart';
import 'b1d_harness.dart';

void main() {
  late B1dHarness h;
  setUp(() async {
    h = B1dHarness();
    await h.seed();
  });
  tearDown(() => h.close());
  for (final table in [
    'local_settings',
    'orders',
    'order_items',
    'payments',
    'order_events',
    'savings_entries',
    'outbox',
  ]) {
    test('checkout rolls back every store and counter when $table fails', () async {
      await h.savings.addEntry(
        SavingsEntry(
          id: h.ids.newId(),
          ownerId: h.owner,
          createdAt: h.at,
          customerId: h.customerId,
          kind: SavingsKind.setor,
          amount: 500,
          method: PayMethod.tunai,
        ),
      );
      final before = await h.snapshot();
      await h.fail(table);
      expect(await checkout(h, term: PayTerm.sekarang, received: 500, savings: true), isNull);
      expect(await h.snapshot(), before);
      expect(await h.local.getInt('order_counter_A'), isNull);
      await h.db.customStatement('DROP TRIGGER injected');
      final id = await checkout(h, term: PayTerm.sekarang, received: 500, savings: true);
      expect((await h.orders.getOrderById(id!))!.orderNo, 'A-0001');
      expect(await h.local.getInt('order_counter_A'), 1);
      final second = await checkout(h);
      expect((await h.orders.getOrderById(second!))!.orderNo, 'A-0002');
      expect(await h.local.getInt('order_counter_A'), 2);
    });
  }
  test('restored order numbers advance only their device counter', () async {
    final id = (await checkout(h))!;
    await h.db.customStatement('UPDATE orders SET order_no = ? WHERE id = ?', ['B-0042', id]);
    await h.local.setString('device_code', 'B');
    await h.local.setInt('order_counter_B', 2);
    final next = await checkout(h);
    expect((await h.orders.getOrderById(next!))!.orderNo, 'B-0043');
    expect(await h.local.getInt('order_counter_B'), 43);
    expect(await h.local.getInt('order_counter_A'), 1);
  });
}
