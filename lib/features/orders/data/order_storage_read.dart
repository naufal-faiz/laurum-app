import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/features/orders/data/order_sql_enum.dart';

Order orderFromRow(OrderRow r) => Order(
  id: r.id,
  ownerId: r.ownerId,
  createdAt: r.createdAt,
  updatedAt: r.updatedAt,
  syncState: RecordSyncState.values.byName(r.syncState),
  orderNo: r.orderNo,
  customerId: r.customerId,
  status: OrderStatus.values.firstWhere((v) => orderSqlEnum(v) == r.status),
  source: OrderSource.values.firstWhere((v) => orderSqlEnum(v) == r.source),
  payTerm: PayTerm.values.byName(r.payTerm),
  proposalId: r.proposalId,
  discount: r.discount,
  note: r.note,
  enteredAt: r.enteredAt.toLocal(),
  estimatedAt: r.estimatedAt,
  subtotal: r.subtotal,
  total: r.total,
  deletedAt: r.deletedAt,
);
