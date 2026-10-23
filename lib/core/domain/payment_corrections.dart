import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/payment.dart';

List<Payment> paymentCorrections(
  Order order,
  Iterable<Payment> payments, {
  required String prefix,
  required DateTime at,
}) {
  final ledger = payments.toList();
  final corrections = <Payment>[];
  for (final method in PayMethod.values) {
    final amount = ledger
        .where(
          (p) =>
              p.ownerId == order.ownerId &&
              p.orderId == order.id &&
              p.method == method &&
              p.deletedAt == null,
        )
        .fold(0, (sum, p) => sum + p.amount);
    if (amount < 0) throw StateError('Negative net payment before cancellation');
    if (amount == 0) continue;
    final id = '$prefix-payment-${method.name}';
    if (ledger.any((p) => p.id == id)) throw ArgumentError('Duplicate correction ID');
    corrections.add(
      Payment(
        id: id,
        ownerId: order.ownerId,
        createdAt: at,
        orderId: order.id,
        method: method,
        amount: -amount,
        received: -amount,
        paidAt: at,
        note: 'Koreksi pembatalan ${order.orderNo}',
      ),
    );
  }
  return List.unmodifiable(corrections);
}
