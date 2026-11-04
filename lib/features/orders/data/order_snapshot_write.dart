import 'package:laurum/core/domain/domain_record.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/record_content.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/core/persistence/sql_timestamp.dart';
import 'package:laurum/features/orders/data/order_event_storage.dart';
import 'package:laurum/features/orders/data/order_item_storage.dart';
import 'package:laurum/features/orders/data/order_storage_write.dart';
import 'package:laurum/features/orders/data/order_store.dart';
import 'package:laurum/features/orders/data/payment_storage.dart';

Future<void> writeOrderSnapshot(
  OutboxWriter writer,
  Order order,
  OrderStore before,
  OrderStore next,
  DateTime at,
) async {
  final db = writer.db;
  await writer.write(
    table: 'orders',
    rowId: order.id,
    payload: orderPayload(order, at),
    mutate: () async {
      await db.into(db.orderRecords).insertOnConflictUpdate(orderToRow(order, at));
      // The memory store moves a saved order to the end; rowid is local ordering only.
      await db.customStatement(
        '''UPDATE orders SET entered_at = ?,
      rowid = (SELECT MAX(rowid) + 1 FROM orders) WHERE id = ?''',
        [sqlTimestamp(order.enteredAt), order.id],
      );
    },
  );
  final items = next.items.where((i) => i.orderId == order.id).toList();
  for (final old in before.items.where((i) => i.orderId == order.id)) {
    if (!items.any((i) => i.id == old.id)) items.add(retiredItem(old, at));
  }
  for (final i in items) {
    await writeOrderChange(writer, i, before.items, 'order_items', itemPayload(i, at), () async {
      await db.into(db.orderItemRecords).insertOnConflictUpdate(itemToRow(i, at));
    });
    await db.customStatement(
      '''UPDATE order_items SET
      rowid = (SELECT MAX(rowid) + 1 FROM order_items) WHERE id = ?''',
      [i.id],
    );
  }
  for (final p in next.payments.where((p) => p.orderId == order.id)) {
    await writeOrderChange(writer, p, before.payments, 'payments', paymentPayload(p, at), () async {
      await db.into(db.paymentRecords).insert(paymentToRow(p, at));
      await db.customStatement('UPDATE payments SET paid_at = ? WHERE id = ?', [
        sqlTimestamp(p.paidAt),
        p.id,
      ]);
    });
  }
  for (final e in next.events.where((e) => e.orderId == order.id)) {
    await writeOrderChange(writer, e, before.events, 'order_events', eventPayload(e, at), () async {
      await db.into(db.orderEventRecords).insert(eventToRow(e, at));
    });
  }
}

Future<void> writeOrderChange(
  OutboxWriter writer,
  DomainRecord value,
  Iterable<DomainRecord> old,
  String table,
  Map<String, Object?> payload,
  Future<void> Function() mutate,
) async {
  if (old.any((r) => sameRecordContent(r, value))) return;
  await writer.write(table: table, rowId: value.id, payload: payload, mutate: mutate);
}

OrderItem retiredItem(OrderItem i, DateTime at) => OrderItem(
  id: i.id,
  ownerId: i.ownerId,
  createdAt: i.createdAt,
  orderId: i.orderId,
  serviceId: i.serviceId,
  serviceName: i.serviceName,
  unit: i.unit,
  qtyMilli: i.qtyMilli,
  unitPrice: i.unitPrice,
  lineTotal: i.lineTotal,
  deletedAt: at,
);
