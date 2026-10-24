import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/features/orders/data/order_fixtures.dart';
import 'package:laurum/features/reports/data/report_daily_fixtures.dart';
import 'package:laurum/features/reports/data/report_fixtures.dart';

List<int?>? reportDailyRevenue(ReportRange range, List<Order> orders, DateTime now) {
  if (range != weekRange) return null;
  int revenue(Iterable<Order> source, ReportRange day) => source
      .where(
        (o) =>
            o.deletedAt == null && o.status != OrderStatus.dibatalkan && day.contains(o.enteredAt),
      )
      .fold(0, (sum, o) => sum + o.total);
  final today = DateTime(now.year, now.month, now.day);
  return List.generate(7, (index) {
    final start = range.start.add(Duration(days: index));
    if (start.isAfter(today)) return null;
    final day = ReportRange(start, start.add(const Duration(days: 1)));
    return (weekDailyRevenueFixtures[index] ?? 0) +
        revenue(orders, day) -
        revenue(orderFixtures, day);
  });
}
