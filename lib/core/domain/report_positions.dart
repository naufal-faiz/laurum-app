import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/savings_entry.dart';
import 'package:laurum/core/domain/savings_rules.dart';

class ReportPositions {
  const ReportPositions({
    required this.outstanding,
    required this.savings,
    required this.unpaidCount,
  });
  final int outstanding, savings, unpaidCount;
}

ReportPositions ledgerPositions(
  Iterable<Order> orders,
  Iterable<Payment> payments,
  Iterable<SavingsEntry> savings,
) {
  final paid = <(String, String), int>{};
  for (final p in payments.where((p) => p.deletedAt == null)) {
    final key = (p.ownerId, p.orderId);
    paid[key] = (paid[key] ?? 0) + p.amount;
  }
  var outstanding = 0, unpaidCount = 0;
  for (final o in orders.where((o) => o.deletedAt == null && o.status != OrderStatus.dibatalkan)) {
    final due = (o.total - (paid[(o.ownerId, o.id)] ?? 0)).clamp(0, o.total);
    outstanding += due;
    if (due > 0) unpaidCount++;
  }
  return ReportPositions(
    outstanding: outstanding,
    savings: savingsBalance(savings),
    unpaidCount: unpaidCount,
  );
}
