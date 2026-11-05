import 'package:drift/drift.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/features/orders/data/order_item_storage.dart';
import 'package:laurum/features/orders/data/payment_storage.dart';

const activeStatusSql = "('menunggu_jemput','diproses','siap')";

Future<List<QueryRow>> _children(AppDatabase db, String owner, String table) {
  if (!const {'order_items', 'payments'}.contains(table)) {
    throw ArgumentError('Invalid child table');
  }
  final child = db.allTables.singleWhere((t) => t.actualTableName == table);
  return db
      .customSelect(
        'SELECT c.* FROM orders o JOIN $table c ON c.order_id = o.id '
        'AND c.owner_id = o.owner_id WHERE o.owner_id = ? '
        'AND o.deleted_at IS NULL AND c.deleted_at IS NULL '
        'AND o.status IN $activeStatusSql ORDER BY c.rowid',
        variables: [Variable<String>(owner)],
        readsFrom: {db.orderRecords, child},
      )
      .get();
}

Future<List<OrderItem>> readActiveItems(AppDatabase db, String owner) async => List.unmodifiable(
  (await _children(
    db,
    owner,
    'order_items',
  )).map((r) => itemFromRow(db.orderItemRecords.map(r.data))),
);
Future<List<Payment>> readActivePayments(AppDatabase db, String owner) async => List.unmodifiable(
  (await _children(
    db,
    owner,
    'payments',
  )).map((r) => paymentFromRow(db.paymentRecords.map(r.data))),
);
