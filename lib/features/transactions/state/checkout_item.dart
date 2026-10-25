import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';

OrderItem checkoutItem(
  String orderId,
  String ownerId,
  DateTime now,
  DraftLine line,
) => OrderItem(
  id: '$orderId-item-${line.service.id}',
  ownerId: ownerId,
  createdAt: now,
  orderId: orderId,
  serviceId: line.service.id,
  serviceName: line.service.name,
  unit: line.service.kind == ServiceKind.kiloan ? 'kg' : 'pcs',
  qtyMilli: line.qtyMilli,
  unitPrice: line.service.price,
  lineTotal: line.total,
);
