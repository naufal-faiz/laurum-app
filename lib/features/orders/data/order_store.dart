import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';

class OrderStore {
  OrderStore({
    required Iterable<Order> orders,
    required Iterable<OrderItem> items,
    required Iterable<Payment> payments,
    required Iterable<OrderEvent> events,
  }) : orders = List.unmodifiable(orders),
       items = List.unmodifiable(items),
       payments = List.unmodifiable(payments),
       events = List.unmodifiable(events);
  final List<Order> orders;
  final List<OrderItem> items;
  final List<Payment> payments;
  final List<OrderEvent> events;
}
