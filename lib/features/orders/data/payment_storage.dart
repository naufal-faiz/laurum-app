import 'package:drift/drift.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/features/orders/data/order_sql_enum.dart';

Payment paymentFromRow(PaymentRow r) => Payment(
  id: r.id,
  ownerId: r.ownerId,
  createdAt: r.createdAt,
  updatedAt: r.updatedAt,
  syncState: RecordSyncState.values.byName(r.syncState),
  orderId: r.orderId,
  method: PayMethod.values.byName(r.method),
  amount: r.amount,
  received: r.received,
  paidAt: r.paidAt.toLocal(),
  note: r.note,
  deletedAt: r.deletedAt,
);

PaymentRecordsCompanion paymentToRow(Payment v, DateTime at) => PaymentRecordsCompanion.insert(
  id: v.id,
  ownerId: v.ownerId,
  createdAt: v.createdAt,
  updatedAt: Value(at),
  syncState: const Value('pending'),
  orderId: v.orderId,
  method: orderSqlEnum(v.method),
  amount: v.amount,
  received: v.received,
  paidAt: v.paidAt,
  note: Value(v.note),
  deletedAt: Value(v.deletedAt),
);

Map<String, Object?> paymentPayload(Payment v, DateTime at) => {
  'id': v.id,
  'owner_id': v.ownerId,
  'created_at': v.createdAt.toUtc().toIso8601String(),
  'updated_at': at.toUtc().toIso8601String(),
  'deleted_at': v.deletedAt?.toUtc().toIso8601String(),
  'order_id': v.orderId,
  'method': orderSqlEnum(v.method),
  'amount': v.amount,
  'received': v.received,
  'paid_at': v.paidAt.toUtc().toIso8601String(),
  'note': v.note,
};
