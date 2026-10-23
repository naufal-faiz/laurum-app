import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/service_revenue.dart';
import 'package:laurum/core/domain/top_services.dart';
import 'package:laurum/features/orders/data/order_store.dart';
import 'package:laurum/features/reports/data/report_fixtures.dart';

List<ServiceRevenue> adjustedTopServices(
  OrderStore initial,
  OrderStore current,
  ReportRange range,
) {
  final base = {for (final s in weekTopServicesFixtures) s.serviceId: s};
  final before = topServices(initial.orders, initial.items, range: range);
  final after = topServices(current.orders, current.items, range: range);
  for (final change in [(rows: before, sign: -1), (rows: after, sign: 1)]) {
    for (final row in change.rows) {
      // The historical "Lainnya" bucket has no measurable unit or quantity.
      final key = base.containsKey(row.serviceId) ? row.serviceId : 'other';
      final previous = base[key]!;
      base[key] = ServiceRevenue(
        serviceId: key,
        serviceName: previous.serviceName,
        unit: previous.unit,
        qtyMilli: key == 'other' ? 0 : previous.qtyMilli + change.sign * row.qtyMilli,
        revenue: previous.revenue + change.sign * row.revenue,
      );
    }
  }
  final rows = base.values.toList()
    ..sort((a, b) {
      final revenue = b.revenue.compareTo(a.revenue);
      return revenue == 0 ? a.serviceId.compareTo(b.serviceId) : revenue;
    });
  return List.unmodifiable(rows);
}
