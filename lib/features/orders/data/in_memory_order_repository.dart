import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/services/transactional_memory.dart';
import 'package:laurum/features/orders/data/in_memory_order_reader.dart';
import 'package:laurum/features/orders/data/order_store.dart';
import 'package:laurum/features/orders/data/order_store_seed.dart';
import 'package:laurum/features/orders/data/order_store_write.dart';

class InMemoryOrderRepository extends InMemoryOrderReader with TransactionalMemory<OrderStore> {
  InMemoryOrderRepository() : _empty = false;
  InMemoryOrderRepository.empty() : _empty = true;
  final bool _empty;
  void clearLocalData() => state = OrderStore(orders: [], items: [], payments: [], events: []);
  @override
  OrderStore build() => initialOrderStore(empty: _empty);
  @override
  Future<void> saveOrder(
    Order order, {
    List<OrderItem>? items,
    List<Payment>? payments,
    List<OrderEvent>? events,
    bool useOrderStatus = true,
  }) async => state = writeOrderStore(
    state,
    order,
    items: items,
    payments: payments ?? [],
    events: events ?? [],
    useOrderStatus: useOrderStatus,
  );
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
