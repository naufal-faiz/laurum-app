import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/order_rules.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/payment_corrections.dart';
import 'package:laurum/core/domain/savings_entry.dart';

({Order order, List<Payment> payments, List<SavingsEntry> savings, OrderEvent event}) cancelOrder(
  Order order, {
  required Iterable<Payment> payments,
  required Iterable<SavingsEntry> savings,
  required String correctionPrefix,
  required DateTime at,
}) {
  if (order.deletedAt != null) throw StateError('Deleted order');
  final status = nextStatus(order.status, cancel: true);
  final corrections = paymentCorrections(order, payments, prefix: correctionPrefix, at: at);
  final refund = -corrections
      .where((p) => p.method == PayMethod.tabungan)
      .fold(0, (sum, p) => sum + p.amount);
  final ledger = savings.toList();
  final used = ledger
      .where(
        (e) =>
            e.ownerId == order.ownerId && e.customerId == order.customerId && e.orderId == order.id,
      )
      .fold(
        0,
        (sum, e) =>
            sum +
            switch (e.kind) {
              SavingsKind.pakai => e.amount,
              SavingsKind.penyesuaian => -e.amount,
              SavingsKind.setor => 0,
            },
      );
  if (refund != used) throw StateError('Savings and payment ledger do not reconcile');
  final id = '$correctionPrefix-savings';
  if (refund > 0 && ledger.any((e) => e.id == id)) throw ArgumentError('Duplicate correction ID');
  return (
    order: order.withStatus(status),
    payments: corrections,
    savings: List<SavingsEntry>.unmodifiable([
      if (refund > 0)
        SavingsEntry(
          id: id,
          ownerId: order.ownerId,
          createdAt: at,
          customerId: order.customerId,
          kind: SavingsKind.penyesuaian,
          amount: refund,
          method: PayMethod.tabungan,
          orderId: order.id,
          note: 'Koreksi pembatalan ${order.orderNo}',
        ),
    ]),
    event: OrderEvent(
      id: '$correctionPrefix-event',
      ownerId: order.ownerId,
      createdAt: at,
      orderId: order.id,
      occurredAt: at,
      kind: 'cancelled',
      fromStatus: order.status,
      toStatus: status,
    ),
  );
}
