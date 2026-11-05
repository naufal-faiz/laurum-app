import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/report_range.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders({OrderStatus? status});
  Future<List<Order>> getActiveOrders();
  Future<List<Order>> getOrdersInRange(ReportRange range, {OrderStatus? status});
  Future<List<Payment>> getPaymentsInRange(ReportRange range);
  Future<Order?> getOrderById(String id);
  Future<Order?> getOrderByOrderNo(String orderNo);
  Future<List<OrderItem>> getItemsByOrderId(String orderId);
  Future<List<OrderItem>> getActiveItems();
  Future<List<Payment>> getActivePayments();
  Future<List<Payment>> getPaymentsByOrderId(String orderId);
  Future<List<Payment>> getAllPayments();
  Future<List<OrderEvent>> getEventsByOrderId(String orderId);

  // Atomic snapshot save: items replace the order's items; ledgers append idempotently.
  // Reusing a ledger ID with different contents is rejected.
  Future<void> saveOrder(
    Order order, {
    List<OrderItem>? items,
    List<Payment>? payments,
    List<OrderEvent>? events,
    bool useOrderStatus = true,
  });

  Future<void> updateOrderStatus(
    String orderId,
    OrderStatus status, {
    OrderEvent? event,
    bool useOrderStatus = true,
  });

  Future<void> addPayment(Payment payment);
  Future<void> addEvent(OrderEvent event);
}
