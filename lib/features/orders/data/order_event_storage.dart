import 'package:drift/drift.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/features/orders/data/order_sql_enum.dart';

OrderEvent eventFromRow(OrderEventRow r) => OrderEvent(
  id: r.id,
  ownerId: r.ownerId,
  createdAt: r.createdAt,
  updatedAt: r.updatedAt,
  syncState: RecordSyncState.values.byName(r.syncState),
  orderId: r.orderId,
  occurredAt: r.occurredAt,
  kind: r.kind,
  note: r.note,
  fromStatus: r.fromStatus == null
      ? null
      : OrderStatus.values.firstWhere((v) => orderSqlEnum(v) == r.fromStatus),
  toStatus: r.toStatus == null
      ? null
      : OrderStatus.values.firstWhere((v) => orderSqlEnum(v) == r.toStatus),
  deletedAt: r.deletedAt,
);

OrderEventRecordsCompanion eventToRow(OrderEvent v, DateTime at) =>
    OrderEventRecordsCompanion.insert(
      id: v.id,
      ownerId: v.ownerId,
      createdAt: v.createdAt,
      updatedAt: Value(at),
      syncState: const Value('pending'),
      orderId: v.orderId,
      occurredAt: v.occurredAt,
      kind: v.kind,
      note: Value(v.note),
      fromStatus: Value(v.fromStatus == null ? null : orderSqlEnum(v.fromStatus!)),
      toStatus: Value(v.toStatus == null ? null : orderSqlEnum(v.toStatus!)),
      deletedAt: Value(v.deletedAt),
    );

Map<String, Object?> eventPayload(OrderEvent v, DateTime at) => {
  'id': v.id,
  'owner_id': v.ownerId,
  'created_at': v.createdAt.toUtc().toIso8601String(),
  'updated_at': at.toUtc().toIso8601String(),
  'deleted_at': v.deletedAt?.toUtc().toIso8601String(),
  'order_id': v.orderId,
  'occurred_at': v.occurredAt.toUtc().toIso8601String(),
  'kind': v.kind,
  'note': v.note,
  'from_status': v.fromStatus == null ? null : orderSqlEnum(v.fromStatus!),
  'to_status': v.toStatus == null ? null : orderSqlEnum(v.toStatus!),
};
