import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/report.dart';
import 'package:laurum/core/domain/report_baseline.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/report_totals.dart';
import 'package:laurum/core/domain/service_revenue.dart';
import 'package:laurum/core/domain/top_services.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/reports/data/report_daily.dart';

typedef CustomReportData = ({
  ReportTotals totals,
  int unpaidCount,
  List<int?>? daily,
  List<ServiceRevenue>? services,
});

Future<CustomReportData> customReportData(Ref ref, ReportRange range) async {
  final repository = ref.watch(orderRepositoryProvider);
  final expenses = ref.watch(expenseRepositoryProvider);
  final savings = ref.watch(savingsRepositoryProvider);
  final orders = await repository.getOrders();
  final payments = await repository.getAllPayments();
  final totals = buildReport(
    baseline: ReportBaseline(range: range),
    range: range,
    orders: orders,
    payments: payments,
    expenses: await expenses.getExpenses(from: range.start, to: range.end),
    savings: await savings.getAllEntries(),
  );
  final active = orders
      .where((o) => o.deletedAt == null && o.status != OrderStatus.dibatalkan)
      .toList();
  final items = <OrderItem>[];
  for (final order in active.where((o) => range.contains(o.enteredAt))) {
    items.addAll(await repository.getItemsByOrderId(order.id));
  }
  List<ServiceRevenue>? services;
  try {
    services = topServices(active, items, range: range);
  } on ArgumentError {
    // Historical notes may lack item snapshots; never invent a service breakdown.
    services = null;
  }
  return (
    totals: totals,
    unpaidCount: active.where((o) => outstanding([o], payments) > 0).length,
    daily: actualDailyRevenue(range, orders),
    services: services,
  );
}
