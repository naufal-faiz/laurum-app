import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/report_range.dart';

const reportPeriodLabels = ['Hari ini', 'Minggu ini', 'Bulan ini'];

class ReportPeriod extends Notifier<int> {
  @override
  int build() => 1;
  void select(int index) => state = index;
}

final reportPeriodProvider = NotifierProvider<ReportPeriod, int>(ReportPeriod.new);

ReportRange reportPeriodRange(int period, DateTime now) {
  final day = DateTime(now.year, now.month, now.day);
  if (period == 0) return ReportRange(day, day.add(const Duration(days: 1)));
  if (period == 2) {
    return ReportRange(DateTime(now.year, now.month), DateTime(now.year, now.month + 1));
  }
  final monday = day.subtract(Duration(days: day.weekday - 1));
  return ReportRange(monday, monday.add(const Duration(days: 7)));
}
