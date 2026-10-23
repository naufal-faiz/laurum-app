import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/core/domain/report.dart';
import 'package:laurum/core/domain/report_baseline.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/report_totals.dart';
import 'package:laurum/core/domain/savings_entry.dart';
import 'package:laurum/features/orders/data/order_store.dart';

ReportTotals reportSnapshot(
  ReportRange range,
  OrderStore orders,
  List<Expense> expenses,
  List<SavingsEntry> savings,
) => buildReport(
  baseline: ReportBaseline(range: range),
  orders: orders.orders,
  payments: orders.payments,
  expenses: expenses,
  savings: savings,
  range: range,
);
