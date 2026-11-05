import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/features/customers/data/customer_history_fixtures.dart';
import 'package:laurum/features/orders/data/order_fixtures.dart';

Map<String, ({int orderCount, int revenue})> memoryCustomerHistoryOffsets() {
  final result = <String, ({int orderCount, int revenue})>{};
  for (final entry in customerHistoryFixtures.entries) {
    final initial = orderFixtures
        .where(
          (o) =>
              o.customerId == entry.key &&
              o.deletedAt == null &&
              o.status != OrderStatus.dibatalkan,
        )
        .toList();
    result[entry.key] = (
      orderCount: entry.value.orderCount - initial.length,
      revenue: entry.value.revenue - initial.fold(0, (sum, o) => sum + o.total),
    );
  }
  return Map.unmodifiable(result);
}
