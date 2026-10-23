import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders({OrderStatus? status});
  Future<Order?> getOrderById(String id);
  Future<Order?> getOrderByOrderNo(String orderNo);
  Future<List<OrderItem>> getItemsByOrderId(String orderId);
  Future<List<Payment>> getPaymentsByOrderId(String orderId);
  Future<List<Payment>> getAllPayments();
  Future<List<OrderEvent>> getEventsByOrderId(String orderId);

  Future<void> saveOrder(
    Order order, {
    List<OrderItem>? items,
    List<Payment>? payments,
    List<OrderEvent>? events,
  });

  Future<void> updateOrderStatus(
    String orderId,
    OrderStatus status, {
    OrderEvent? event,
  });

  Future<void> addPayment(Payment payment);
  Future<void> addEvent(OrderEvent event);
}
