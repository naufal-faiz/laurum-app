import 'package:drift/drift.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/savings_entry.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/sql_timestamp.dart';

SavingsEntry savingsFromRow(SavingsRow r) => SavingsEntry(
  id: r.id,
  ownerId: r.ownerId,
  createdAt: r.createdAt,
  updatedAt: r.updatedAt,
  syncState: RecordSyncState.values.byName(r.syncState),
  customerId: r.customerId,
  kind: SavingsKind.values.byName(r.kind),
  amount: r.amount,
  method: PayMethod.values.byName(r.method),
  orderId: r.orderId,
  note: r.note,
);
SavingsRecordsCompanion savingsToRow(SavingsEntry e, DateTime at) => SavingsRecordsCompanion.insert(
  id: e.id,
  ownerId: e.ownerId,
  createdAt: e.createdAt,
  createdKey: Value(sqlTimestamp(e.createdAt)),
  updatedAt: Value(at),
  syncState: const Value('pending'),
  customerId: e.customerId,
  kind: e.kind.name,
  amount: e.amount,
  method: e.method.name,
  orderId: Value(e.orderId),
  note: Value(e.note),
);
Map<String, Object?> savingsPayload(SavingsEntry e, DateTime at) => {
  'id': e.id,
  'owner_id': e.ownerId,
  'created_at': e.createdAt.toUtc().toIso8601String(),
  'updated_at': at.toUtc().toIso8601String(),
  'customer_id': e.customerId,
  'kind': e.kind.name,
  'amount': e.amount,
  'method': e.method.name,
  'order_id': e.orderId,
  'note': e.note,
};
