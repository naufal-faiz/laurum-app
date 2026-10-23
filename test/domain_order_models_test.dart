import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';

import 'domain_samples.dart';

void main() {
  test('order copy preserves snapshot and enforces forward-only status', () {
    final original = order('o');
    final updated = original.withStatus(OrderStatus.siap);
    expect(updated.id, original.id);
    expect(updated.total, original.total);
    expect(updated.customerId, original.customerId);
    expect(updated.estimatedAt, original.estimatedAt);
    expect(original, order('o'));
    expect(original, isNot(updated));
    expect(() => original.withStatus(OrderStatus.menungguJemput), throwsStateError);
    expect(
      () => order('o', status: OrderStatus.selesai).withStatus(OrderStatus.diproses),
      throwsStateError,
    );
  });
  test('ledger and item equality include values, not just IDs', () {
    expect(item('i'), item('i'));
    expect(item('i'), isNot(item('i', amount: 10)));
    expect(payment('p'), payment('p'));
    expect(payment('p'), isNot(payment('p', amount: 10)));
    expect(saving('s'), saving('s'));
    expect(saving('s'), isNot(saving('s', amount: 10)));
  });
}
