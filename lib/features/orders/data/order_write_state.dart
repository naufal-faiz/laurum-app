import 'package:drift/drift.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/features/orders/data/order_event_storage.dart';
import 'package:laurum/features/orders/data/order_item_storage.dart';
import 'package:laurum/features/orders/data/order_storage_read.dart';
import 'package:laurum/features/orders/data/order_store.dart';
import 'package:laurum/features/orders/data/payment_storage.dart';

Future<OrderStore> loadOrderWriteState(
  AppDatabase db,
  Order order,
  List<OrderItem> items,
  List<Payment> payments,
  List<OrderEvent> events,
) async {
  final orders =
      await (db.select(db.orderRecords)..where(
            (r) =>
                r.id.equals(order.id) |
                (r.ownerId.equals(order.ownerId) & r.orderNo.equals(order.orderNo)),
          ))
          .get();
  final lines =
      await (db.select(db.orderItemRecords)..where(
            (r) =>
                (r.orderId.equals(order.id) & r.deletedAt.isNull()) |
                r.id.isIn(items.map((i) => i.id)),
          ))
          .get();
  final paid = await (db.select(
    db.paymentRecords,
  )..where((r) => r.orderId.equals(order.id) | r.id.isIn(payments.map((p) => p.id)))).get();
  final history = await (db.select(
    db.orderEventRecords,
  )..where((r) => r.orderId.equals(order.id) | r.id.isIn(events.map((e) => e.id)))).get();
  return OrderStore(
    orders: orders.map(orderFromRow),
    items: lines.map(itemFromRow),
    payments: paid.map(paymentFromRow),
    events: history.map(eventFromRow),
  );
}

Future<void> validateOrderParents(AppDatabase db, Order order, Iterable<OrderItem> items) async {
  final customer = await (db.select(
    db.customerRecords,
  )..where((r) => r.id.equals(order.customerId))).getSingleOrNull();
  if (customer == null || customer.ownerId != order.ownerId) {
    throw StateError('Customer belongs to another account or is missing');
  }
  final services =
      await (db.select(db.serviceRecords)..where(
            (r) => r.id.isIn(items.map((i) => i.serviceId)) & r.ownerId.equals(order.ownerId),
          ))
          .get();
  if (items.any((i) => !services.any((s) => s.id == i.serviceId))) {
    throw StateError('Service belongs to another account or is missing');
  }
}
