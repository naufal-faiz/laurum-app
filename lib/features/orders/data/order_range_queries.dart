import 'package:drift/drift.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/sql_timestamp.dart';
import 'package:laurum/features/orders/data/active_order_queries.dart';
import 'package:laurum/features/orders/data/order_sql_enum.dart';
import 'package:laurum/features/orders/data/order_storage_read.dart';
import 'package:laurum/features/orders/data/payment_storage.dart';

Future<List<Order>> readOrders(
  AppDatabase db,
  String owner, {
  OrderStatus? status,
  ReportRange? range,
  String? id,
  String? number,
  bool activeOnly = false,
}) async {
  final conditions = ['owner_id = ?', 'deleted_at IS NULL'];
  if (activeOnly) conditions.add('status IN $activeStatusSql');
  final values = <String>[owner];
  for (final (column, value) in [
    ('status', status == null ? null : orderSqlEnum(status)),
    ('id', id),
    ('order_no', number),
  ]) {
    if (value != null) {
      conditions.add('$column = ?');
      values.add(value);
    }
  }
  if (range != null) {
    conditions.add('entered_at >= ? AND entered_at < ?');
    values.addAll([sqlTimestamp(range.start), sqlTimestamp(range.end)]);
  }
  final rows = await db
      .customSelect(
        'SELECT * FROM orders WHERE ${conditions.join(' AND ')} ORDER BY rowid',
        variables: values.map(Variable<String>.new).toList(),
        readsFrom: {db.orderRecords},
      )
      .get();
  return List.unmodifiable(rows.map((r) => orderFromRow(db.orderRecords.map(r.data))));
}

Future<List<Payment>> readPayments(
  AppDatabase db,
  String owner, {
  String? orderId,
  ReportRange? range,
  bool includeDeleted = false,
}) async {
  final conditions = ['owner_id = ?', if (!includeDeleted) 'deleted_at IS NULL'];
  final values = <String>[owner];
  if (orderId != null) {
    conditions.add('order_id = ?');
    values.add(orderId);
  }
  if (range != null) {
    conditions.add('paid_at >= ? AND paid_at < ?');
    values.addAll([sqlTimestamp(range.start), sqlTimestamp(range.end)]);
  }
  final rows = await db
      .customSelect(
        'SELECT * FROM payments WHERE ${conditions.join(' AND ')} ORDER BY rowid',
        variables: values.map(Variable<String>.new).toList(),
        readsFrom: {db.paymentRecords},
      )
      .get();
  return List.unmodifiable(rows.map((r) => paymentFromRow(db.paymentRecords.map(r.data))));
}
