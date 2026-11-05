import 'package:drift/drift.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/repositories/order_repository.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/features/orders/data/active_order_queries.dart';
import 'package:laurum/features/orders/data/order_event_storage.dart';
import 'package:laurum/features/orders/data/order_item_storage.dart';
import 'package:laurum/features/orders/data/order_range_queries.dart';

abstract class DriftOrderReader implements OrderRepository {
  DriftOrderReader(this.db, this.ownerId);
  final AppDatabase db;
  final String ownerId;
  @override
  Future<List<OrderItem>> getActiveItems() => readActiveItems(db, ownerId);
  @override
  Future<List<Order>> getActiveOrders() => readOrders(db, ownerId, activeOnly: true);
  @override
  Future<List<Payment>> getActivePayments() => readActivePayments(db, ownerId);
  @override
  Future<List<Order>> getOrders({OrderStatus? status}) => readOrders(db, ownerId, status: status);
  @override
  Future<List<Order>> getOrdersInRange(ReportRange range, {OrderStatus? status}) =>
      readOrders(db, ownerId, range: range, status: status);
  @override
  Future<List<Payment>> getPaymentsInRange(ReportRange range) =>
      readPayments(db, ownerId, range: range);
  @override
  Future<Order?> getOrderById(String id) async =>
      (await readOrders(db, ownerId, id: id)).firstOrNull;
  @override
  Future<Order?> getOrderByOrderNo(String orderNo) async =>
      (await readOrders(db, ownerId, number: orderNo)).firstOrNull;
  @override
  Future<List<OrderItem>> getItemsByOrderId(String orderId) async {
    final rows =
        await (db.select(db.orderItemRecords)
              ..where(
                (r) => r.ownerId.equals(ownerId) & r.orderId.equals(orderId) & r.deletedAt.isNull(),
              )
              ..orderBy([(r) => OrderingTerm.asc(r.rowId)]))
            .get();
    return List.unmodifiable(rows.map(itemFromRow));
  }

  @override
  Future<List<Payment>> getPaymentsByOrderId(String orderId) =>
      readPayments(db, ownerId, orderId: orderId);
  @override
  Future<List<Payment>> getAllPayments() => readPayments(db, ownerId, includeDeleted: true);
  @override
  Future<List<OrderEvent>> getEventsByOrderId(String orderId) async {
    final rows =
        await (db.select(db.orderEventRecords)
              ..where((r) => r.ownerId.equals(ownerId) & r.orderId.equals(orderId))
              ..orderBy([(r) => OrderingTerm.asc(r.rowId)]))
            .get();
    return List.unmodifiable(rows.map(eventFromRow));
  }
}
