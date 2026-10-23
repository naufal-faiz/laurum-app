import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/savings_entry.dart';

int savingsBalance(Iterable<SavingsEntry> entries, {String? customerId}) => entries
    .where((e) => customerId == null || e.customerId == customerId)
    .fold(0, (sum, e) => sum + (e.kind == SavingsKind.pakai ? -e.amount : e.amount));

// Persist both returned entries in one transaction; this function writes nothing.
({Payment payment, SavingsEntry savings}) applySavings(
  Order order, {
  required Iterable<Payment> payments,
  required Iterable<SavingsEntry> savings,
  required int amount,
  required String paymentId,
  required String savingsId,
  required DateTime at,
}) {
  if (order.status == OrderStatus.dibatalkan || order.deletedAt != null) {
    throw StateError('Inactive order');
  }
  final ledger = savings.toList();
  final cash = payments.toList();
  final balance = savingsBalance(
    ledger.where((e) => e.ownerId == order.ownerId),
    customerId: order.customerId,
  );
  final due = outstanding([order], cash.where((p) => p.ownerId == order.ownerId));
  if (amount <= 0 || amount > balance || amount > due) {
    throw ArgumentError('Invalid savings amount');
  }
  if (cash.any((p) => p.id == paymentId) || ledger.any((e) => e.id == savingsId)) {
    throw ArgumentError('Duplicate ledger ID');
  }
  return (
    payment: Payment(
      id: paymentId,
      ownerId: order.ownerId,
      createdAt: at,
      orderId: order.id,
      method: PayMethod.tabungan,
      amount: amount,
      received: amount,
      paidAt: at,
    ),
    savings: SavingsEntry(
      id: savingsId,
      ownerId: order.ownerId,
      createdAt: at,
      customerId: order.customerId,
      kind: SavingsKind.pakai,
      amount: amount,
      method: PayMethod.tabungan,
      orderId: order.id,
    ),
  );
}
