import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/repositories/order_repository.dart';
import 'package:laurum/features/orders/data/order_fixtures.dart';
import 'package:laurum/features/orders/data/order_item_fixtures.dart';
import 'package:laurum/features/orders/data/payment_fixtures.dart';

class InMemoryOrderRepository extends Notifier<List<Order>> implements OrderRepository {
  final List<OrderItem> _items = List.of(orderItemFixtures);
  final List<Payment> _payments = List.of(paymentFixtures);
  final List<OrderEvent> _events = [];

  @override
  List<Order> build() => List.of(orderFixtures);

  @override
  Future<List<Order>> getOrders({OrderStatus? status}) async {
    if (status == null) return state;
    return state.where((o) => o.status == status).toList();
  }

  @override
  Future<Order?> getOrderById(String id) async {
    final match = state.where((o) => o.id == id);
    return match.isEmpty ? null : match.first;
  }

  @override
  Future<Order?> getOrderByOrderNo(String orderNo) async {
    final match = state.where((o) => o.orderNo == orderNo);
    return match.isEmpty ? null : match.first;
  }

  @override
  Future<List<OrderItem>> getItemsByOrderId(String orderId) async =>
      _items.where((i) => i.orderId == orderId).toList();

  @override
  Future<List<Payment>> getPaymentsByOrderId(String orderId) async =>
      _payments.where((p) => p.orderId == orderId).toList();

  @override
  Future<List<Payment>> getAllPayments() async => List.unmodifiable(_payments);

  @override
  Future<List<OrderEvent>> getEventsByOrderId(String orderId) async =>
      _events.where((e) => e.orderId == orderId).toList();

  @override
  Future<void> saveOrder(
    Order order, {
    List<OrderItem>? items,
    List<Payment>? payments,
    List<OrderEvent>? events,
  }) async {
    if (items != null) _items.addAll(items);
    if (payments != null) _payments.addAll(payments);
    if (events != null) _events.addAll(events);
    final idx = state.indexWhere((o) => o.id == order.id);
    if (idx >= 0) {
      state = [
        for (var i = 0; i < state.length; i++)
          if (i == idx) order else state[i],
      ];
    } else {
      state = [...state, order];
    }
  }

  @override
  Future<void> updateOrderStatus(
    String orderId,
    OrderStatus status, {
    OrderEvent? event,
  }) async {
    if (event != null) _events.add(event);
    state = [
      for (final o in state)
        if (o.id == orderId) o.withStatus(status) else o,
    ];
  }

  @override
  Future<void> addPayment(Payment payment) async {
    _payments.add(payment);
    state = List.of(state);
  }

  @override
  Future<void> addEvent(OrderEvent event) async {
    _events.add(event);
  }
}

final inMemoryOrderRepositoryProvider = NotifierProvider<InMemoryOrderRepository, List<Order>>(
  InMemoryOrderRepository.new,
);
