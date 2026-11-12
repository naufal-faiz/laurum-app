import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/report_totals.dart';
import 'package:laurum/core/domain/service_revenue.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/reports/state/report_custom_range.dart';
import 'package:laurum/features/reports/state/report_daily_view.dart';
import 'package:laurum/features/reports/state/report_period.dart';
import 'package:laurum/features/shell/state/shell_state.dart';

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
  int get dailyAverage {
    final values = daily?.whereType<int>().toList() ?? <int>[];
    return values.isEmpty ? 0 : values.fold<int>(0, (sum, n) => sum + n) ~/ values.length;
  }

  String? get peakDayName {
    final values = daily;
    if (period != 1 || values == null) return null;
    final peak = values.whereType<int>().fold<int>(0, (a, b) => a > b ? a : b);
    if (peak == 0) return null;
    return ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'][values.indexOf(peak)];
  }

  bool get isEmpty =>
      totals.transactionCount == 0 &&
      totals.revenue == 0 &&
      totals.expenses == 0 &&
      totals.cashIn == 0;
  List<String> get dayLabels => period == 3
      ? [
          for (var i = 0; i < (daily?.length ?? 0); i++)
            Formatters.tanggal(range.start.add(Duration(days: i)), ringkas: true),
        ]
      : period == 0
      ? ['Hari ini']
      : ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
}

final reportViewProvider = FutureProvider<ReportView>(
  (ref) => _loadReport(ref, ref.watch(reportPeriodProvider)),
);
final weeklyReportViewProvider = FutureProvider<ReportView>((ref) => _loadReport(ref, 1));

Future<ReportView> _loadReport(Ref ref, int period) async {
  final now = ref.watch(businessClockProvider)();
  final custom = period == 3 ? ref.watch(reportCustomRangeProvider) : null;
  final range = reportPeriodRange(period, now, custom: custom);
  final reports = ref.watch(reportRepositoryProvider);
  final totals = await reports.getReport(range);
  final amounts = await reports.getDailyRevenue(range);
  List<ServiceRevenue>? services;
  try {
    services = await reports.getTopServices(range);
  } on ArgumentError {
    // An incomplete historical snapshot has no invented service attribution.
    services = null;
  }
  return ReportView(
    period: period,
    range: range,
    totals: totals,
    unpaidCount: await reports.getUnpaidCount(),
    daily: visibleDailyRevenue(range, amounts, now),
    services: services,
  );
}
