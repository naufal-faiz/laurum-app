import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/record_content.dart';

void validateOrderPayments(
  Order order,
  List<Payment> old,
  List<Payment> added,
  List<Payment> next,
) {
  for (final p in added) {
    if (old.any((existing) => sameRecordContent(existing, p))) continue;
    if (p.deletedAt != null ||
        p.amount == 0 ||
        (p.amount < 0 && order.status != OrderStatus.dibatalkan) ||
        (p.amount < 0 && p.received != p.amount) ||
        (p.amount > 0 &&
            (p.received < p.amount || (p.method != PayMethod.tunai && p.received != p.amount)))) {
      throw ArgumentError('Invalid payment amount');
    }
  }
  final active = next.where((p) => p.orderId == order.id && p.deletedAt == null);
  if (active.fold<int>(0, (sum, p) => sum + p.amount) > order.total ||
      PayMethod.values.any(
        (method) =>
            active.where((p) => p.method == method).fold<int>(0, (sum, p) => sum + p.amount) < 0,
      )) {
    throw StateError('Payment exceeds order balance');
  }
}
