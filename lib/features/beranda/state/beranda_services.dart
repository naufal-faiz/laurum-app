import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_item.dart';

enum BerandaStageTone { primary, illustration, success }

/// Count each active order once per service, even if it has duplicate lines.
List<({String label, int value, BerandaStageTone tone})> berandaServices(
  List<Order> orders,
  Map<String, List<OrderItem>> items,
) {
  final counts = <String, Set<String>>{};
  final names = <String, String>{};
  for (final order in orders) {
    for (final item in items[order.id] ?? <OrderItem>[]) {
      if (item.deletedAt != null || item.orderId != order.id) continue;
      (counts[item.serviceId] ??= {}).add(order.id);
      names[item.serviceId] = item.serviceName;
    }
  }
  final ids = counts.keys.toList()
    ..sort((a, b) {
      final count = counts[b]!.length.compareTo(counts[a]!.length);
      return count != 0 ? count : names[a]!.compareTo(names[b]!);
    });
  return [
    for (final (i, id) in ids.take(3).indexed)
      (label: names[id]!, value: counts[id]!.length, tone: BerandaStageTone.values[i]),
  ];
}
