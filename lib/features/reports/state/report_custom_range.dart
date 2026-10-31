import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/report_range.dart';

ReportRange selectedReportRange(DateTime start, DateTime end, DateTime now) {
  if (start.isUtc || end.isUtc || now.isUtc) throw ArgumentError('Supply local dates');
  final first = DateTime(start.year, start.month, start.day);
  final last = DateTime(end.year, end.month, end.day);
  final today = DateTime(now.year, now.month, now.day);
  if (first.isBefore(DateTime(2026)) || last.isAfter(today) || last.isBefore(first)) {
    throw ArgumentError('Range must be within 2026 and today');
  }
  return ReportRange(first, DateTime(last.year, last.month, last.day + 1));
}

final reportCustomRangeProvider = NotifierProvider<ReportCustomRange, ReportRange?>(
  ReportCustomRange.new,
);

class ReportCustomRange extends Notifier<ReportRange?> {
  @override
  ReportRange? build() => null;
  void select(DateTime start, DateTime end, {required DateTime now}) =>
      state = selectedReportRange(start, end, now);
}
