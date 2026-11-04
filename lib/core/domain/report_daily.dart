import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/report_range.dart';

List<int> dailyRevenue(ReportRange range, Iterable<Order> orders) {
  final days = range.end.difference(range.start).inDays;
  final result = List.filled(days, 0);
  for (final o in orders) {
    if (o.deletedAt != null || o.status == OrderStatus.dibatalkan || !range.contains(o.enteredAt)) {
      continue;
    }
    final index = o.enteredAt.difference(range.start).inDays;
    if (index >= 0 && index < days) result[index] += o.total;
  }
  return List.unmodifiable(result);
}
