import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/features/reports/state/report_range_draft.dart';

class ReportRangeController extends Notifier<ReportRangeDraft?> {
  @override
  ReportRangeDraft? build() => null;

  void begin({
    required DateTime firstDate,
    required DateTime lastDate,
    required DateTime start,
    required DateTime end,
  }) => state = ReportRangeDraft(
    firstDate: firstDate,
    lastDate: lastDate,
    month: DateTime(start.year, start.month),
    start: start,
    end: end,
  );

  void selectDay(DateTime date) {
    final current = state!;
    final day = DateTime(date.year, date.month, date.day);
    if (day.isBefore(current.firstDate) || day.isAfter(current.lastDate)) return;
    final restart = current.start == null || current.end != null || day.isBefore(current.start!);
    state = current.withDates(
      month: DateTime(day.year, day.month),
      start: restart ? day : current.start,
      end: restart ? null : day,
    );
  }

  void moveMonth(DateTime date) {
    final current = state!;
    final month = DateTime(date.year, date.month);
    if (month.isBefore(DateTime(current.firstDate.year, current.firstDate.month)) ||
        month.isAfter(DateTime(current.lastDate.year, current.lastDate.month))) {
      return;
    }
    state = current.withDates(start: current.start, end: current.end, month: month);
  }

  void reset() => state = state!.withDates();
}

final reportRangeDraftProvider = NotifierProvider<ReportRangeController, ReportRangeDraft?>(
  ReportRangeController.new,
);
