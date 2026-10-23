import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/report_baseline.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/report_totals.dart';
import 'package:laurum/core/domain/savings_entry.dart';
import 'package:laurum/core/domain/savings_rules.dart';

// Supply all current delta ledgers, including entries outside the flow range.
ReportTotals buildReport({
  required ReportBaseline baseline,
  required Iterable<Order> orders,
  required Iterable<Payment> payments,
  required Iterable<Expense> expenses,
  required Iterable<SavingsEntry> savings,
  required ReportRange range,
}) {
  if (baseline.range != range) throw ArgumentError('Baseline range does not match');
  final active = orders
      .where((o) => o.deletedAt == null && o.status != OrderStatus.dibatalkan)
      .toList();
  final cohort = active.where((o) => range.contains(o.enteredAt)).toList();
  final ledger = payments.where((p) => p.deletedAt == null).toList();
  final deposits = savings.toList();
  var cashFromOrders = 0;
  var savingsUsed = 0;
  var newOutstanding = 0;
  for (final order in cohort) {
    final matched = ledger.where((p) => p.ownerId == order.ownerId && p.orderId == order.id);
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
  final base = baseline.totals;
  return ReportTotals(
    revenue: base.revenue + cohort.fold<int>(0, (sum, o) => sum + o.total),
    transactionCount: base.transactionCount + cohort.length,
    expenses:
        base.expenses +
        expenses
            .where((e) => e.deletedAt == null && range.contains(e.spentAt))
            .fold<int>(0, (sum, e) => sum + e.amount),
    cashIn:
        base.cashIn +
        ledger
            .where((p) => p.method != PayMethod.tabungan && range.contains(p.paidAt))
            .fold<int>(0, (sum, p) => sum + p.amount) +
        deposits
            .where(
              (e) =>
                  e.kind == SavingsKind.setor &&
                  e.method != PayMethod.tabungan &&
                  range.contains(e.createdAt),
            )
            .fold<int>(0, (sum, e) => sum + e.amount),
    activeOutstanding: base.activeOutstanding + outstanding(active, ledger),
    savingsBalance: base.savingsBalance + savingsBalance(deposits),
    cashFromOrders: base.cashFromOrders + cashFromOrders,
    savingsUsed: base.savingsUsed + savingsUsed,
    newOutstanding: base.newOutstanding + newOutstanding,
  );
}
