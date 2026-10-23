import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/revenue_allocation.dart';
import 'package:laurum/core/domain/service_revenue.dart';

List<ServiceRevenue> topServices(
  Iterable<Order> orders,
  Iterable<OrderItem> items, {
  ReportRange? range,
}) {
  final snapshots = items.where((i) => i.deletedAt == null).toList();
  final grouped = <String, ServiceRevenue>{};
  final active =
      orders
          .where(
            (o) =>
                o.deletedAt == null &&
                o.status != OrderStatus.dibatalkan &&
                (range == null || range.contains(o.enteredAt)),
          )
          .toList()
        ..sort((a, b) {
          final date = a.enteredAt.compareTo(b.enteredAt);
          return date != 0 ? date : a.id.compareTo(b.id);
        });
  for (final order in active) {
    final lines = snapshots
        .where((i) => i.ownerId == order.ownerId && i.orderId == order.id)
        .toList();
    if (lines.fold(0, (sum, i) => sum + i.lineTotal) != order.subtotal) {
      throw ArgumentError('Incomplete order item snapshots');
    }
    final allocated = allocateRevenue(lines, order.total);
    for (final item in lines) {
      final key = '${item.serviceId}|${item.unit}';
      final old = grouped[key];
      grouped[key] = ServiceRevenue(
        serviceId: item.serviceId,
        serviceName: item.serviceName,
        unit: item.unit,
        qtyMilli: (old?.qtyMilli ?? 0) + item.qtyMilli,
        revenue: (old?.revenue ?? 0) + allocated[item.id]!,
      );
    }
  }
  final ranked = grouped.values.toList()
    ..sort((a, b) {
      final revenue = b.revenue.compareTo(a.revenue);
      if (revenue != 0) return revenue;
      final id = a.serviceId.compareTo(b.serviceId);
      return id != 0 ? id : a.unit.compareTo(b.unit);
    });
  return List.unmodifiable(ranked);
}
