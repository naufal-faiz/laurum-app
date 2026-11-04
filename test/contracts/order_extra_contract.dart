import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/repositories/order_repository.dart';

import '../domain_samples.dart';
import 'order_values.dart';
import 'repository_factory.dart';

void runOrderExtraContract(RepositoryFactory<OrderRepository> factory) {
  for (final (amount, received, method) in [
    (0, 0, PayMethod.tunai),
    (-1, -1, PayMethod.tunai),
    (100, 99, PayMethod.tunai),
    (100, 101, PayMethod.qris),
  ]) {
    test('invalid payment rejects atomically: $amount/$received/$method', () async {
      final repo = await factory();
      await repo.saveOrder(order('o', total: 1000), items: [item('i')]);
      await expectLater(
        repo.addPayment(payment('bad', amount: amount, received: received, method: method)),
        throwsArgumentError,
      );
      expect(await repo.getAllPayments(), isEmpty);
    });
  }
  test('overpayment rejects and final snapshot can retry with storage metadata', () async {
    final repo = await factory();
    final original = order('o', total: 1000);
    await repo.saveOrder(original, items: [item('i')]);
    await expectLater(repo.addPayment(payment('bad', amount: 1001)), throwsStateError);
    await repo.updateOrderStatus('o', OrderStatus.siap);
    final finished = (await repo.getOrderById('o'))!.withStatus(OrderStatus.selesai);
    await repo.saveOrder(finished, payments: [payment('p', amount: 1000)]);
    await repo.saveOrder(finished, payments: [payment('p', amount: 1000)]);
    expect((await repo.getPaymentsByOrderId('o')).map(paymentValue), [
      paymentValue(payment('p', amount: 1000)),
    ]);
  });
  test('item replacement and order update preserve memory ordering semantics', () async {
    final repo = await factory();
    await repo.saveOrder(order('o', total: 1000), items: [item('old')]);
    await repo.saveOrder(order('other', total: 1000), items: [item('other-i', orderId: 'other')]);
    await repo.saveOrder(order('o', total: 1000), items: [item('new')]);
    expect((await repo.getOrders()).map((o) => o.id), ['other', 'o']);
    expect((await repo.getItemsByOrderId('o')).map((i) => i.id), ['new']);
  });
  test('range boundaries preserve microseconds', () async {
    final repo = await factory();
    final end = day.add(const Duration(microseconds: 2));
    final range = ReportRange(day, end);
    for (final (id, at) in [
      ('start', day),
      ('micro', end.subtract(const Duration(microseconds: 1))),
      ('end', end),
    ]) {
      await repo.saveOrder(
        order(id, total: 1000, enteredAt: at),
        items: [item('i-$id', orderId: id)],
        payments: [payment('p-$id', orderId: id, paidAt: at)],
      );
    }
    expect((await repo.getOrdersInRange(range)).map((o) => o.id), ['start', 'micro']);
    expect((await repo.getPaymentsInRange(range)).map((p) => p.id), ['p-start', 'p-micro']);
  });
}
