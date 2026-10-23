import 'package:laurum/core/domain/order_item.dart';

// Largest-remainder allocation: net service revenue sums exactly to order total.
Map<String, int> allocateRevenue(List<OrderItem> items, int total) {
  final sum = items.fold(0, (value, i) => value + i.lineTotal);
  if (total < 0 || total > sum || items.map((i) => i.id).toSet().length != items.length) {
    throw ArgumentError('Invalid revenue allocation');
  }
  if (sum == 0) return {for (final item in items) item.id: 0};
  final weights =
      items.map((item) {
        final numerator = BigInt.from(item.lineTotal) * BigInt.from(total);
        return (
          id: item.id,
          whole: (numerator ~/ BigInt.from(sum)).toInt(),
          remainder: numerator % BigInt.from(sum),
        );
      }).toList()..sort((a, b) {
        final comparison = b.remainder.compareTo(a.remainder);
        return comparison != 0 ? comparison : a.id.compareTo(b.id);
      });
  final result = {for (final weight in weights) weight.id: weight.whole};
  final remainder = total - weights.fold(0, (sum, w) => sum + w.whole);
  for (var i = 0; i < remainder; i++) {
    final id = weights[i].id;
    result[id] = result[id]! + 1;
  }
  return result;
}
