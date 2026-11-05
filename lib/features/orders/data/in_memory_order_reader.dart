import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/repositories/order_repository.dart';
import 'package:laurum/features/orders/data/order_store.dart';

abstract class InMemoryOrderReader extends Notifier<OrderStore> implements OrderRepository {
  @override
  Future<List<Order>> getOrders({OrderStatus? status}) async => List.unmodifiable(
    state.orders.where((o) => o.deletedAt == null && (status == null || o.status == status)),
  );
  @override
  Future<List<Order>> getOrdersInRange(ReportRange range, {OrderStatus? status}) async =>
      List.unmodifiable(
        (await getOrders(status: status)).where((o) => range.contains(o.enteredAt)),
      );
  @override
  Future<List<Payment>> getPaymentsInRange(ReportRange range) async => List.unmodifiable(
    state.payments.where((p) => p.deletedAt == null && range.contains(p.paidAt)),
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
  Future<List<Order>> getActiveOrders() async => List.unmodifiable(
    state.orders.where(
      (o) =>
          o.deletedAt == null &&
          o.status != OrderStatus.selesai &&
          o.status != OrderStatus.dibatalkan,
    ),
  );
  @override
  Future<List<OrderItem>> getActiveItems() async {
    final ids = (await getActiveOrders()).map((o) => o.id).toSet();
    return List.unmodifiable(
      state.items.where((i) => ids.contains(i.orderId) && i.deletedAt == null),
    );
  }

  @override
  Future<List<Payment>> getActivePayments() async {
    final ids = (await getActiveOrders()).map((o) => o.id).toSet();
    return List.unmodifiable(
      state.payments.where((p) => ids.contains(p.orderId) && p.deletedAt == null),
    );
  }

  @override
  Future<List<OrderEvent>> getEventsByOrderId(String orderId) async =>
      List.unmodifiable(state.events.where((e) => e.orderId == orderId));
}
