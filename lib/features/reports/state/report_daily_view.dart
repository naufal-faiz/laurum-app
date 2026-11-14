import 'package:laurum/core/domain/report_range.dart';

List<int?>? visibleDailyRevenue(
  ReportRange range,
  List<int> amounts,
  DateTime now, {
  bool allowLongRange = false,
}) {
  if (amounts.length > 7 && !allowLongRange) return null;
  final today = DateTime(now.year, now.month, now.day);
  return List.unmodifiable([
    for (var i = 0; i < amounts.length; i++)
      range.start.add(Duration(days: i)).isAfter(today) ? null : amounts[i],
  ]);
}
