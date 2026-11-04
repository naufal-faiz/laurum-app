import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/features/orders/data/drift_order_reader.dart';
import 'package:laurum/features/orders/data/order_snapshot_write.dart';
import 'package:laurum/features/orders/data/order_store_write.dart';
import 'package:laurum/features/orders/data/order_write_state.dart';

class DriftOrderRepository extends DriftOrderReader {
  DriftOrderRepository(super.db, super.ownerId, this.writer, {DateTime Function()? clock})
    : clock = clock ?? DateTime.now {
    if (!identical(db, writer.db)) throw ArgumentError('Outbox belongs to another database');
  }
  final OutboxWriter writer;
  final DateTime Function() clock;
  @override
  Future<void> saveOrder(
    Order order, {
    List<OrderItem>? items,
    List<Payment>? payments,
    List<OrderEvent>? events,
    bool useOrderStatus = true,
  }) => writer.runner.run(() async {
    if (order.ownerId != ownerId) throw StateError('Order belongs to another account');
    final before = await loadOrderWriteState(db, order, items ?? [], payments ?? [], events ?? []);
    final next = writeOrderStore(
      before,
      order,
      items: items,
      payments: payments ?? [],
      events: events ?? [],
      useOrderStatus: useOrderStatus,
    );
    await validateOrderParents(db, order, next.items.where((i) => i.orderId == order.id));
    await writeOrderSnapshot(writer, order, before, next, clock());
  });
  @override
  Future<void> updateOrderStatus(
    String orderId,
    OrderStatus status, {
    OrderEvent? event,
    bool useOrderStatus = true,
  }) => writer.runner.run(() async {
    final order = await getOrderById(orderId);
    if (order == null) throw StateError('Order not found');
    await saveOrder(
      order.withStatus(status, useOrderStatus: useOrderStatus),
      events: [?event],
      useOrderStatus: useOrderStatus,
    );
  });
  @override
  Future<void> addPayment(Payment payment) => writer.runner.run(() async {
    final order = await getOrderById(payment.orderId);
    if (order == null) throw StateError('Order not found');
    await saveOrder(order, payments: [payment]);
  });
  @override
  Future<void> addEvent(OrderEvent event) => writer.runner.run(() async {
    final order = await getOrderById(event.orderId);
    if (order == null) throw StateError('Order not found');
    await saveOrder(order, events: [event]);
  });
}
