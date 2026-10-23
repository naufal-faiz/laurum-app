import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order_rules.dart';

import 'domain_samples.dart';

void main() {
  test('ready uses longest calendar duration at 17 WIB', () {
    expect(
      estimateReady(DateTime(2026, 10, 16, 23, 30), [service('a', days: 2), service('b', days: 3)]),
      DateTime(2026, 10, 19, 17),
    );
    expect(estimateReady(DateTime(2024, 2, 28), [service('a', days: 2)]), DateTime(2024, 3, 1, 17));
    expect(
      estimateReady(DateTime(2026, 12, 31), [service('a')]),
      DateTime(2027, 1, 1, 17),
    );
    expect(
      estimateReady(DateTime(2026, 1, 1, 23), [service('a', days: 0)]),
      DateTime(2026, 1, 1, 17),
    );
    expect(() => estimateReady(DateTime(2026), []), throwsArgumentError);
    expect(() => estimateReady(DateTime.utc(2026), [service('a')]), throwsArgumentError);
  });
  test('status progresses one step and final status cannot change', () {
    expect(nextStatus(OrderStatus.menungguJemput), OrderStatus.diproses);
    expect(nextStatus(OrderStatus.diproses), OrderStatus.siap);
    expect(nextStatus(OrderStatus.siap), OrderStatus.selesai);
    expect(nextStatus(OrderStatus.diproses, cancel: true), OrderStatus.dibatalkan);
    for (final status in [OrderStatus.selesai, OrderStatus.dibatalkan]) {
      expect(() => nextStatus(status), throwsStateError);
      expect(() => nextStatus(status, cancel: true), throwsStateError);
    }
  });
}
