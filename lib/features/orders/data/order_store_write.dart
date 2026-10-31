import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/domain_record.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/features/orders/data/order_store.dart';

List<T> appendLedger<T extends DomainRecord>(Iterable<T> old, Iterable<T> added) {
  final byId = {for (final row in old) row.id: row};
  for (final row in added) {
    final existing = byId[row.id];
    if (existing != null && existing != row) throw StateError('Ledger is immutable');
    byId[row.id] = row;
  }
  return List.unmodifiable(byId.values);
}

OrderStore writeOrderStore(
  OrderStore state,
  Order order, {
  List<OrderItem>? items,
  List<Payment> payments = const [],
  List<OrderEvent> events = const [],
  bool useOrderStatus = true,
}) {
  final old = state.orders.where((o) => o.id == order.id).firstOrNull;
  if (old != null && old != order) {
    if (old.status == OrderStatus.selesai || old.status == OrderStatus.dibatalkan) {
      throw StateError('Order status is final');
    }
    if (old.status != order.status) {
      old.withStatus(order.status, useOrderStatus: useOrderStatus);
    }
    if (old.ownerId != order.ownerId || old.customerId != order.customerId) {
      throw StateError('Order identity cannot change');
    }
  }
  if (state.orders.any((o) => o.id != order.id && o.orderNo == order.orderNo)) {
    throw StateError('Duplicate order number');
  }
  if ((items ?? []).any((i) => i.orderId != order.id || i.ownerId != order.ownerId) ||
      payments.any((p) => p.orderId != order.id || p.ownerId != order.ownerId) ||
      events.any((e) => e.orderId != order.id || e.ownerId != order.ownerId)) {
    throw ArgumentError('Child record belongs to another order');
  }
  final nextItems = items ?? state.items.where((i) => i.orderId == order.id).toList();
  if (nextItems.map((i) => i.id).toSet().length != nextItems.length ||
      nextItems.where((i) => i.deletedAt == null).fold<int>(0, (s, i) => s + i.lineTotal) !=
          order.subtotal) {
    throw ArgumentError('Items must match order subtotal without duplicate IDs');
  }
  if (old != null && (old.status == OrderStatus.selesai || old.status == OrderStatus.dibatalkan)) {
    final original = state.items.where((i) => i.orderId == order.id).toList();
    if (original.length != nextItems.length || !nextItems.every(original.contains)) {
      throw StateError('Final order items cannot change');
    }
  }
  if (order.deletedAt != null ||
      (order.status == OrderStatus.dibatalkan &&
          payments.any((p) => p.amount > 0 && !state.payments.contains(p)))) {
    throw StateError('Cannot pay a deleted or cancelled order');
  }
  final unrelated = state.items.where((i) => i.orderId != order.id).toList();
  if (unrelated.any((i) => nextItems.any((n) => n.id == i.id))) {
    throw ArgumentError('Item ID already belongs to another order');
  }
  final nextPayments = appendLedger(state.payments, payments);
  if (order.status == OrderStatus.dibatalkan &&
      PayMethod.values.any(
        (method) =>
            nextPayments
                .where((p) => p.orderId == order.id && p.method == method && p.deletedAt == null)
                .fold<int>(0, (sum, p) => sum + p.amount) !=
            0,
      )) {
    throw StateError('Cancellation requires payment corrections in the same save');
  }
  return OrderStore(
    orders: [
      for (final o in state.orders)
        if (o.id != order.id) o,
      order,
    ],
    items: [...unrelated, ...nextItems],
    payments: nextPayments,
    events: appendLedger(state.events, events),
  );
}
