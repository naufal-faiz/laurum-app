import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/features/reports/state/report_custom_range.dart';
import 'package:laurum/features/reports/state/report_export.dart';
import 'package:laurum/features/reports/state/report_period.dart';
import 'package:laurum/features/shell/state/shell_state.dart';

Future<void> pickReportRange(BuildContext context, WidgetRef ref) async {
  final now = ref.read(businessClockProvider)();
  final today = DateTime(now.year, now.month, now.day);
  final custom = ref.read(reportCustomRangeProvider);
  final first = DateTime(2026);
  final previous = custom ?? reportPeriodRange(ref.read(reportPeriodProvider), now);
  final start = previous.start.isBefore(first) ? first : previous.start;
  final inclusiveEnd = previous.end.subtract(const Duration(days: 1));
  final end = inclusiveEnd.isAfter(today) ? today : inclusiveEnd;
  final picked = await showDateRangePicker(
    context: context,
    firstDate: first,
    lastDate: today,
    currentDate: today,
    initialDateRange: DateTimeRange(start: start.isAfter(end) ? end : start, end: end),
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    helpText: 'Pilih rentang tanggal',
    saveText: 'Terapkan',
    cancelText: 'Batal',
  );
  if (picked == null || !context.mounted) return;
  ref.read(reportCustomRangeProvider.notifier).select(picked.start, picked.end, now: now);
  ref.read(reportPeriodProvider.notifier).select(3);
  ref.read(reportExportProvider.notifier).reset();
}
