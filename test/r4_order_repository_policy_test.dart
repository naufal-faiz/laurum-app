import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/repositories/order_repository.dart';
import 'package:laurum/features/orders/data/in_memory_order_repository.dart';

void main() {
  late ProviderContainer container;
  late OrderRepository repository;
  setUp(() {
    container = ProviderContainer();
    repository = container.read(inMemoryOrderRepositoryProvider.notifier);
  });
  tearDown(() => container.dispose());

  for (final snapshot in [false, true]) {
    test('snapshot=$snapshot rejects direct completion by default, allows normal chain', () async {
      final order = (await repository.getOrderById('ord-0142'))!;
      await expectLater(finishOrder(repository, order, snapshot: snapshot), throwsStateError);
      expect((await repository.getOrderById(order.id))!.status, OrderStatus.diproses);
      await repository.updateOrderStatus(order.id, OrderStatus.siap);
      final ready = (await repository.getOrderById(order.id))!;
      await finishOrder(repository, ready, snapshot: snapshot);
      expect((await repository.getOrderById(order.id))!.status, OrderStatus.selesai);
    });

    test('snapshot=$snapshot completes unpaid order in simplified mode with its event', () async {
      final order = (await repository.getOrderById('ord-0142'))!;
      final payments = await repository.getPaymentsByOrderId(order.id);
      expect(payments, isEmpty);
      final at = DateTime(2026, 10, 31);
      final event = OrderEvent(
        id: 'r4-complete',
        ownerId: order.ownerId,
        createdAt: at,
        orderId: order.id,
        occurredAt: at,
        kind: 'status',
        fromStatus: order.status,
        toStatus: OrderStatus.selesai,
      );
      await finishOrder(repository, order, snapshot: snapshot, useOrderStatus: false, event: event);
      final completed = (await repository.getOrderById(order.id))!;
      expect(completed.status, OrderStatus.selesai);
      expect(completed.total, order.total);
      expect(await repository.getPaymentsByOrderId(order.id), orderedEquals(payments));
      expect(await repository.getEventsByOrderId(order.id), contains(event));
      expect(
        (await repository.getOrders(status: OrderStatus.diproses)).map((o) => o.id),
        isNot(contains(order.id)),
      );
    });

    test('snapshot=$snapshot cannot reopen a completed order in simplified mode', () async {
      final order = (await repository.getOrderById('ord-0142'))!;
      await finishOrder(repository, order, snapshot: snapshot, useOrderStatus: false);
      await expectLater(
        snapshot
            ? repository.saveOrder(order, useOrderStatus: false)
            : repository.updateOrderStatus(order.id, OrderStatus.diproses, useOrderStatus: false),
        throwsStateError,
      );
      expect((await repository.getOrderById(order.id))!.status, OrderStatus.selesai);
    });
  }
}

Future<void> finishOrder(
  OrderRepository repository,
  Order order, {
  required bool snapshot,
  bool useOrderStatus = true,
  OrderEvent? event,
}) => snapshot
    ? repository.saveOrder(
        order.withStatus(OrderStatus.selesai, useOrderStatus: false),
        events: [?event],
        useOrderStatus: useOrderStatus,
      )
    : repository.updateOrderStatus(
        order.id,
        OrderStatus.selesai,
        event: event,
        useOrderStatus: useOrderStatus,
      );
