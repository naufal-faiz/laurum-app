import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/repositories/order_repository.dart';

import '../domain_samples.dart';
import 'order_extra_contract.dart';
import 'order_item_contract.dart';
import 'order_payment_contract.dart';
import 'order_values.dart';
import 'repository_factory.dart';

void runOrderRepositoryContract(RepositoryFactory<OrderRepository> factory) {
  runOrderPaymentContract(factory);
  runOrderItemContract(factory);
  runOrderExtraContract(factory);
  late OrderRepository repo;
  setUp(() async => repo = await factory());
  test('snapshot retry preserves items, payments and events without duplicates', () async {
    final row = order('o', total: 1000);
    final line = item('i');
    final paid = payment('p');
    final event = OrderEvent(
      id: 'e',
      ownerId: 'owner',
      createdAt: day,
      orderId: 'o',
      occurredAt: day,
      kind: 'created',
    );
    expect(await repo.getOrders(), isEmpty);
    for (var n = 0; n < 2; n++) {
      await repo.saveOrder(row, items: [line], payments: [paid], events: [event]);
    }
    expect((await repo.getOrders()).map(orderValue), [orderValue(row)]);
    expect(orderValue(await repo.getOrderById('o')), orderValue(row));
    expect(orderValue(await repo.getOrderByOrderNo('o')), orderValue(row));
    expect(await repo.getOrderById('missing'), isNull);
    expect((await repo.getItemsByOrderId('o')).map(itemValue), [itemValue(line)]);
    expect((await repo.getPaymentsByOrderId('o')).map(paymentValue), [paymentValue(paid)]);
    expect((await repo.getEventsByOrderId('o')).map(eventValue), [eventValue(event)]);
    expect((await repo.getOrders()).clear, throwsUnsupportedError);
    await expectLater(repo.addPayment(payment('p', amount: 50)), throwsStateError);
    expect((await repo.getAllPayments()).map(paymentValue), [paymentValue(paid)]);
  });
  test('invalid snapshot is atomic and status cannot move back from final', () async {
    await repo.saveOrder(order('o', total: 1000), items: [item('i')]);
    await expectLater(
      repo.saveOrder(order('o', total: 999), items: [item('i')]),
      throwsArgumentError,
    );
    expect((await repo.getOrderById('o'))!.total, 1000);
    await repo.updateOrderStatus('o', OrderStatus.siap);
    await repo.updateOrderStatus('o', OrderStatus.selesai);
    await expectLater(repo.updateOrderStatus('o', OrderStatus.diproses), throwsStateError);
    expect(await repo.getOrders(status: OrderStatus.selesai), hasLength(1));
  });
  test('range is half open, filters status, payments use paidAt independently', () async {
    final range = ReportRange(day, day.add(const Duration(days: 1)));
    for (final (id, at) in [
      ('before', day.subtract(const Duration(seconds: 1))),
      ('start', day),
      ('end', range.end),
    ]) {
      await repo.saveOrder(
        order(id, total: 1000, enteredAt: at),
        items: [item('i-$id', orderId: id)],
        payments: [payment('p-$id', orderId: id, paidAt: at)],
      );
    }
    expect((await repo.getOrdersInRange(range)).map((o) => o.id), ['start']);
    expect(await repo.getOrdersInRange(range, status: OrderStatus.siap), isEmpty);
    expect((await repo.getPaymentsInRange(range)).map((p) => p.id), ['p-start']);
    await repo.addPayment(payment('later', orderId: 'before', paidAt: day));
    expect((await repo.getPaymentsInRange(range)).map((p) => p.id), ['p-start', 'later']);
  });
}
