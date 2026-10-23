import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';

int lineTotal({required int qtyMilli, required int unitPrice}) {
  if (qtyMilli < 0 || unitPrice < 0) throw ArgumentError('Quantity and price must be nonnegative');
  final value =
      (BigInt.from(qtyMilli) * BigInt.from(unitPrice) + BigInt.from(500)) ~/ BigInt.from(1000);
  if (value.bitLength > 53) throw RangeError('Total exceeds exact cross-platform integer range');
  return value.toInt();
}

int orderTotal(Iterable<OrderItem> items, {int discount = 0}) {
  final subtotal = items.where((i) => i.deletedAt == null).fold(0, (sum, i) => sum + i.lineTotal);
  if (discount < 0 || discount > subtotal) throw ArgumentError('Invalid discount');
  return subtotal - discount;
}

int paidAmount(Iterable<Payment> payments, {String? orderId}) => payments
    .where((p) => p.deletedAt == null && (orderId == null || p.orderId == orderId))
    .fold(0, (sum, p) => sum + p.amount);
PayStatus payStatus({required int total, required int paid}) {
  if (total < 0 || paid < 0) throw ArgumentError('Total and net payment must be nonnegative');
  if (paid == 0) return PayStatus.belumBayar;
  return paid < total ? PayStatus.dp : PayStatus.lunas;
}

int outstanding(Iterable<Order> orders, Iterable<Payment> payments) {
  final ledger = payments.toList();
  return orders
      .where((o) => o.deletedAt == null && o.status != OrderStatus.dibatalkan)
      .fold(0, (sum, o) => sum + (o.total - paidAmount(ledger, orderId: o.id)).clamp(0, o.total));
}
