import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/report_totals.dart';
import 'package:laurum/core/domain/service_revenue.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/reports/data/report_daily.dart';
import 'package:laurum/features/reports/pages/report_period.dart';
import 'package:laurum/features/shell/pages/shell_state.dart';

class ReportView {
  const ReportView({
    required this.period,
    required this.range,
    required this.totals,
    required this.unpaidCount,
    this.daily,
    this.services,
  });
  final int period, unpaidCount;
  final ReportRange range;
  final ReportTotals totals;
  final List<int?>? daily;
  final List<ServiceRevenue>? services;
  bool get isEmpty =>
      totals.transactionCount == 0 &&
      totals.revenue == 0 &&
      totals.expenses == 0 &&
      totals.cashIn == 0;
  List<String> get dayLabels =>
      period == 0 ? ['Hari ini'] : ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
}

final reportViewProvider = FutureProvider<ReportView>((ref) async {
  final period = ref.watch(reportPeriodProvider);
  final now = ref.watch(businessClockProvider)();
  final reports = ref.watch(reportRepositoryProvider);
  final repository = ref.watch(orderRepositoryProvider);
  final range = reportPeriodRange(period, now);
  final totals = await reports.getReport(range);
  final orders = await repository.getOrders();
  final payments = await repository.getAllPayments();
  List<ServiceRevenue>? services;
  try {
    services = (await reports.getTopServices(range)).toList()
      ..sort((a, b) => b.revenue.compareTo(a.revenue));
  } on UnsupportedError {
    services = null;
  }
  return ReportView(
    period: period,
    range: range,
    totals: totals,
    unpaidCount: orders
        .where(
          (o) =>
              o.deletedAt == null &&
              o.status != OrderStatus.dibatalkan &&
              outstanding([o], payments) > 0,
        )
        .length,
    daily: period == 0 ? [totals.revenue] : reportDailyRevenue(range, orders, now),
    services: services,
  );
});
