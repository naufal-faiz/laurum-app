import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';

import 'domain_samples.dart';

void main() {
  test('lineTotal rounds half up using integers', () {
    expect(lineTotal(qtyMilli: 3500, unitPrice: 9000), 31500);
    expect(lineTotal(qtyMilli: 499, unitPrice: 1), 0);
    expect(lineTotal(qtyMilli: 500, unitPrice: 1), 1);
    expect(lineTotal(qtyMilli: 0, unitPrice: 9000), 0);
    expect(() => lineTotal(qtyMilli: -1, unitPrice: 1), throwsArgumentError);
    expect(() => lineTotal(qtyMilli: 1, unitPrice: -1), throwsArgumentError);
  });
  test('totals validate discount and preserve item snapshots', () {
    expect(orderTotal([item('i'), item('j', amount: 500)], discount: 100), 1400);
    expect(orderTotal([]), 0);
    expect(() => orderTotal([item('i', amount: 100)], discount: 101), throwsArgumentError);
    expect(() => orderTotal([], discount: -1), throwsArgumentError);
  });
  test('payments use amount, not cash tender, including corrections', () {
    final ledger = [
      payment('p', amount: 6500, received: 10000),
      payment('q', amount: -500),
      payment('other', orderId: 'other', amount: 999),
    ];
    expect(paidAmount(ledger, orderId: 'o'), 6000);
    expect(payStatus(total: 10000, paid: 0), PayStatus.belumBayar);
    expect(payStatus(total: 10000, paid: 6000), PayStatus.dp);
    expect(payStatus(total: 10000, paid: 11000), PayStatus.lunas);
    expect(payStatus(total: 0, paid: 0), PayStatus.belumBayar);
    expect(() => payStatus(total: 1, paid: -1), throwsArgumentError);
  });
  test('outstanding clamps each order and excludes cancellations', () {
    expect(
      outstanding(
        [
          order('o'),
          order('b', total: 80),
          order('x', total: 90, status: OrderStatus.dibatalkan),
        ],
        [payment('a', amount: 150), payment('b', orderId: 'b', amount: 20)],
      ),
      60,
    );
  });
}
