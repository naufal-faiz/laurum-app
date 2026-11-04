import 'package:drift/drift.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/features/orders/data/order_sql_enum.dart';

OrderRecordsCompanion orderToRow(Order v, DateTime at) => OrderRecordsCompanion.insert(
  id: v.id,
  ownerId: v.ownerId,
  createdAt: v.createdAt,
  updatedAt: Value(at),
  syncState: const Value('pending'),
  orderNo: v.orderNo,
  customerId: v.customerId,
  status: orderSqlEnum(v.status),
  source: orderSqlEnum(v.source),
  payTerm: Value(orderSqlEnum(v.payTerm)),
  proposalId: Value(v.proposalId),
  discount: Value(v.discount),
  note: Value(v.note),
  enteredAt: v.enteredAt,
  estimatedAt: v.estimatedAt,
  subtotal: v.subtotal,
  total: v.total,
  deletedAt: Value(v.deletedAt),
);

Map<String, Object?> orderPayload(Order v, DateTime at) => {
  'id': v.id,
  'owner_id': v.ownerId,
  'created_at': v.createdAt.toUtc().toIso8601String(),
  'updated_at': at.toUtc().toIso8601String(),
  'deleted_at': v.deletedAt?.toUtc().toIso8601String(),
  'order_no': v.orderNo,
  'customer_id': v.customerId,
  'status': orderSqlEnum(v.status),
  'source': orderSqlEnum(v.source),
  'pay_term': orderSqlEnum(v.payTerm),
  'proposal_id': v.proposalId,
  'discount': v.discount,
  'note': v.note,
  'entered_at': v.enteredAt.toUtc().toIso8601String(),
  'estimated_at': v.estimatedAt.toUtc().toIso8601String(),
  'subtotal': v.subtotal,
  'total': v.total,
};
