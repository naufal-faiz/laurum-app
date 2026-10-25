import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';

OrderItem orderEditItem(
  DraftLine line,
  Order order,
  List<OrderItem> current,
  DateTime now,
) {
  final existing = current.where((item) => item.serviceId == line.service.id).firstOrNull;
  return OrderItem(
    id: existing?.id ?? '${order.id}-item-${line.service.id}',
    ownerId: order.ownerId,
    createdAt: existing?.createdAt ?? now,
    orderId: order.id,
    serviceId: line.service.id,
    serviceName: line.service.name,
    unit: line.service.kind == ServiceKind.kiloan ? 'kg' : 'pcs',
    qtyMilli: line.qtyMilli,
    unitPrice: line.service.price,
    lineTotal: line.total,
  );
}
