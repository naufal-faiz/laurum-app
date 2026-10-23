import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/top_services.dart';

import 'domain_samples.dart';

void main() {
  test('rank revenue rather than volume, excluding cancelled orders', () {
    final ranked = topServices(
      [order('o', total: 300), order('x', total: 999, status: OrderStatus.dibatalkan)],
      [
        item('a', serviceId: 'highVolume', qtyMilli: 10000, amount: 100),
        item('b', serviceId: 'highRevenue', amount: 200),
        item('c', orderId: 'x', serviceId: 'cancelled', amount: 999),
      ],
    );
    expect(ranked.map((s) => s.serviceId), ['highRevenue', 'highVolume']);
    expect(ranked.first.revenue, 200);
  });
  test('discount allocated in whole rupiah, ties deterministic', () {
    final rows = [item('a', serviceId: 'a', amount: 5), item('b', serviceId: 'b', amount: 5)];
    final ranked = topServices([order('o', total: 9, discount: 1)], rows);
    expect(ranked.map((s) => s.revenue), [5, 4]);
    expect(ranked.first.serviceId, 'a');
    expect(ranked.clear, throwsUnsupportedError);
  });
  test('missing snapshot items are rejected instead of understating revenue', () {
    expect(
      () => topServices([order('o')], [item('a', amount: 50)]),
      throwsArgumentError,
    );
    expect(topServices([], []), isEmpty);
  });
}
