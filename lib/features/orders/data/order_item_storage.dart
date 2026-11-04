import 'package:drift/drift.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/persistence/app_database.dart';

OrderItem itemFromRow(OrderItemRow r) => OrderItem(
  id: r.id,
  ownerId: r.ownerId,
  createdAt: r.createdAt,
  updatedAt: r.updatedAt,
  syncState: RecordSyncState.values.byName(r.syncState),
  orderId: r.orderId,
  serviceId: r.serviceId,
  serviceName: r.serviceName,
  unit: r.unit,
  qtyMilli: r.qtyMilli,
  unitPrice: r.unitPrice,
  lineTotal: r.lineTotal,
  deletedAt: r.deletedAt,
);

OrderItemRecordsCompanion itemToRow(OrderItem v, DateTime at) => OrderItemRecordsCompanion.insert(
  id: v.id,
  ownerId: v.ownerId,
  createdAt: v.createdAt,
  updatedAt: Value(at),
  syncState: const Value('pending'),
  orderId: v.orderId,
  serviceId: v.serviceId,
  serviceName: v.serviceName,
  unit: v.unit,
  qtyMilli: v.qtyMilli,
  unitPrice: v.unitPrice,
  lineTotal: v.lineTotal,
  deletedAt: Value(v.deletedAt),
);

Map<String, Object?> itemPayload(OrderItem v, DateTime at) => {
  'id': v.id,
  'owner_id': v.ownerId,
  'created_at': v.createdAt.toUtc().toIso8601String(),
  'updated_at': at.toUtc().toIso8601String(),
  'deleted_at': v.deletedAt?.toUtc().toIso8601String(),
  'order_id': v.orderId,
  'service_id': v.serviceId,
  'service_name': v.serviceName,
  'unit': v.unit,
  'qty_milli': v.qtyMilli,
  'unit_price': v.unitPrice,
  'line_total': v.lineTotal,
};
