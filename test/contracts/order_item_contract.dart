import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/repositories/order_repository.dart';

import '../domain_samples.dart';
import 'repository_factory.dart';

void runOrderItemContract(RepositoryFactory<OrderRepository> factory) {
  test('item snapshot preserves supplied order even when existing IDs are reordered', () async {
    final repo = await factory();
    final a = item('a', amount: 500), b = item('b', amount: 500);
    await repo.saveOrder(order('o', total: 1000), items: [a, b]);
    await repo.saveOrder(order('o', total: 1000), items: [b, a]);
    expect((await repo.getItemsByOrderId('o')).map((i) => i.id), ['b', 'a']);
    await repo.saveOrder(order('o', total: 1000), items: [item('replacement')]);
    expect((await repo.getItemsByOrderId('o')).map((i) => i.id), ['replacement']);
    expect((await repo.getActiveItems()).map((i) => i.id), ['replacement']);
    expect((await repo.getActiveItems()).clear, throwsUnsupportedError);
    expect((await repo.getActiveOrders()).single.id, 'o');
    await repo.addPayment(payment('paid'));
    expect((await repo.getActivePayments()).single.id, 'paid');
    await repo.updateOrderStatus('o', OrderStatus.siap);
    await repo.updateOrderStatus('o', OrderStatus.selesai);
    expect(await repo.getActiveOrders(), isEmpty);
    expect(await repo.getActiveItems(), isEmpty);
    expect(await repo.getActivePayments(), isEmpty);
  });
}
