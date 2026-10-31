import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/repositories/order_repository.dart';
import 'package:laurum/features/orders/data/order_event_fixtures.dart';
import 'package:laurum/features/orders/data/order_fixtures.dart';
import 'package:laurum/features/orders/data/order_item_fixtures.dart';
import 'package:laurum/features/orders/data/order_store.dart';
import 'package:laurum/features/orders/data/order_store_write.dart';
import 'package:laurum/features/orders/data/payment_fixtures.dart';

class InMemoryOrderRepository extends Notifier<OrderStore> implements OrderRepository {
  @override
  OrderStore build() => OrderStore(
    orders: orderFixtures,
    items: orderItemFixtures,
    payments: paymentFixtures,
    events: orderEventFixtures,
  );
  @override
  Future<List<Order>> getOrders({OrderStatus? status}) async => List.unmodifiable(
    state.orders.where((o) => o.deletedAt == null && (status == null || o.status == status)),
  );
  @override
  Future<Order?> getOrderById(String id) async =>
      state.orders.where((o) => o.id == id && o.deletedAt == null).firstOrNull;
  @override
  Future<Order?> getOrderByOrderNo(String orderNo) async =>
      state.orders.where((o) => o.orderNo == orderNo && o.deletedAt == null).firstOrNull;
  @override
  Future<List<OrderItem>> getItemsByOrderId(String orderId) async => List.unmodifiable(
    state.items.where((i) => i.orderId == orderId && i.deletedAt == null),
  );
  @override
  Future<List<Payment>> getPaymentsByOrderId(String orderId) async => List.unmodifiable(
    state.payments.where((p) => p.orderId == orderId && p.deletedAt == null),
  );
  @override
  Future<List<Payment>> getAllPayments() async => state.payments;
  @override
  Future<List<OrderEvent>> getEventsByOrderId(String orderId) async =>
      List.unmodifiable(state.events.where((e) => e.orderId == orderId));

  @override
  Future<void> saveOrder(
    Order order, {
    List<OrderItem>? items,
    List<Payment>? payments,
    List<OrderEvent>? events,
    bool useOrderStatus = true,
  }) async {
    state = writeOrderStore(
      state,
      order,
      items: items,
      payments: payments ?? [],
      events: events ?? [],
      useOrderStatus: useOrderStatus,
    );
  }

  @override
  Future<void> updateOrderStatus(
    String orderId,
    OrderStatus status, {
    OrderEvent? event,
    bool useOrderStatus = true,
  }) async {
    final order = state.orders.where((o) => o.id == orderId).firstOrNull;
    if (order == null) throw StateError('Order not found');
    state = writeOrderStore(
      state,
      order.withStatus(status, useOrderStatus: useOrderStatus),
      events: [?event],
      useOrderStatus: useOrderStatus,
    );
  }

  @override
  Future<void> addPayment(Payment payment) async {
    final order = state.orders.where((o) => o.id == payment.orderId).firstOrNull;
    if (order == null) throw StateError('Order not found');
    state = writeOrderStore(state, order, payments: [payment]);
  }

  @override
  Future<void> addEvent(OrderEvent event) async {
    final order = state.orders.where((o) => o.id == event.orderId).firstOrNull;
    if (order == null) throw StateError('Order not found');
    state = writeOrderStore(state, order, events: [event]);
  }
}

final inMemoryOrderRepositoryProvider = NotifierProvider<InMemoryOrderRepository, OrderStore>(
  InMemoryOrderRepository.new,
);
