import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/id_generator.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';

OrderItem checkoutItem(
  String orderId,
  String ownerId,
  DateTime now,
  DraftLine line,
  IdGenerator ids,
) => OrderItem(
  id: ids.newId(),
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

OrderEvent checkoutCreatedEvent(Order order, DateTime now, IdGenerator ids) => OrderEvent(
  id: ids.newId(),
  ownerId: order.ownerId,
  createdAt: now,
  orderId: order.id,
  occurredAt: now,
  kind: 'created',
  toStatus: order.status,
);

Payment checkoutCashPayment(String id, Order order, PayMethod method, int amount, int received) =>
    Payment(
      id: id,
      ownerId: order.ownerId,
      createdAt: order.createdAt,
      orderId: order.id,
      method: method,
      amount: amount,
      received: received,
      paidAt: order.createdAt,
    );
