import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/report_positions.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/report_totals.dart';
import 'package:laurum/core/domain/savings_entry.dart';

// Supply full ledgers, or a range cohort/flow with current SQL positions supplied.
ReportTotals buildReport({
  required Iterable<Order> orders,
  required Iterable<Payment> payments,
  required Iterable<Expense> expenses,
  required Iterable<SavingsEntry> savings,
  required ReportRange range,
  ReportPositions? positions,
}) {
  final active = orders
      .where((o) => o.deletedAt == null && o.status != OrderStatus.dibatalkan)
      .toList();
  final cohort = active.where((o) => range.contains(o.enteredAt)).toList();
  final ledger = payments.where((p) => p.deletedAt == null).toList();
  final deposits = savings.toList();
  final current = positions ?? ledgerPositions(active, ledger, deposits);
  final byOrder = <(String, String), List<Payment>>{};
  for (final p in ledger) {
    byOrder.putIfAbsent((p.ownerId, p.orderId), () => []).add(p);
  }
  var cashFromOrders = 0;
  var savingsUsed = 0;
  var newOutstanding = 0;
  for (final order in cohort) {
    final matched = byOrder[(order.ownerId, order.id)] ?? <Payment>[];
    final used = matched
        .where((p) => p.method == PayMethod.tabungan)
        .fold<int>(0, (sum, p) => sum + p.amount)
        .clamp(0, order.total);
    final cash = matched
        .where((p) => p.method != PayMethod.tabungan)
        .fold<int>(0, (sum, p) => sum + p.amount)
        .clamp(0, order.total - used);
    savingsUsed += used;
    cashFromOrders += cash;
    newOutstanding += order.total - used - cash;
  }
  return ReportTotals(
    revenue: cohort.fold<int>(0, (sum, o) => sum + o.total),
    transactionCount: cohort.length,
    expenses: expenses
        .where((e) => e.deletedAt == null && range.contains(e.spentAt))
        .fold<int>(0, (sum, e) => sum + e.amount),
    cashIn:
        ledger
            .where((p) => p.method != PayMethod.tabungan && range.contains(p.paidAt))
            .fold<int>(0, (sum, p) => sum + p.amount) +
        deposits
            .where(
              (e) =>
                  e.kind == SavingsKind.setor &&
                  e.method != PayMethod.tabungan &&
                  range.contains(e.createdAt.toLocal()),
            )
            .fold<int>(0, (sum, e) => sum + e.amount),
    activeOutstanding: current.outstanding,
    savingsBalance: current.savings,
    cashFromOrders: cashFromOrders,
    savingsUsed: savingsUsed,
    newOutstanding: newOutstanding,
  );
}
