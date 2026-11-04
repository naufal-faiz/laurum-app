import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';

Object? orderValue(Order? o) => o == null
    ? null
    : (
        o.id,
        o.ownerId,
        o.createdAt,
        o.orderNo,
        o.customerId,
        o.status,
        o.source,
        o.payTerm,
        o.proposalId,
        o.discount,
        o.note,
        o.enteredAt,
        o.estimatedAt,
        o.subtotal,
        o.total,
        o.deletedAt,
      );
Object itemValue(OrderItem i) => (
  i.id,
  i.ownerId,
  i.createdAt,
  i.orderId,
  i.serviceId,
  i.serviceName,
  i.unit,
  i.qtyMilli,
  i.unitPrice,
  i.lineTotal,
  i.deletedAt,
);
Object paymentValue(Payment p) => (
  p.id,
  p.ownerId,
  p.createdAt,
  p.orderId,
  p.method,
  p.amount,
  p.received,
  p.paidAt,
  p.note,
  p.deletedAt,
);
Object eventValue(OrderEvent e) => (
  e.id,
  e.ownerId,
  e.createdAt,
  e.orderId,
  e.occurredAt,
  e.kind,
  e.note,
  e.fromStatus,
  e.toStatus,
  e.deletedAt,
);
