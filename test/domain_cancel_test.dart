import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/cancellation.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/domain/savings_rules.dart';

import 'domain_samples.dart';

void main() {
  test('cancel reverses net payments and returns used savings, without deleting', () {
    final original = order('o');
    final payments = [
      payment('cash', amount: 60, received: 100),
      payment('partial', amount: -10),
      payment('s', amount: 40, method: PayMethod.tabungan),
    ];
    final savings = [
      saving('deposit'),
      saving('use', orderId: 'o', amount: 40, kind: SavingsKind.pakai),
    ];
    final result = cancelOrder(
      original,
      payments: payments,
      savings: savings,
      correctionPrefix: 'cancel',
      at: day,
    );
    expect(original.status, OrderStatus.diproses);
    expect(result.order.status, OrderStatus.dibatalkan);
    expect(result.payments.map((p) => p.amount), [-50, -40]);
    expect(paidAmount([...payments, ...result.payments]), 0);
    expect(savingsBalance([...savings, ...result.savings]), 100);
    expect(result.event.fromStatus, OrderStatus.diproses);
    expect(result.event.toStatus, OrderStatus.dibatalkan);
    expect(result.payments.clear, throwsUnsupportedError);
  });
  test('cancel unpaid order has no ledger entries and cannot repeat', () {
    final result = cancelOrder(
      order('o'),
      payments: [],
      savings: [],
      correctionPrefix: 'x',
      at: day,
    );
    expect(result.payments, isEmpty);
    expect(result.savings, isEmpty);
    expect(
      () => cancelOrder(result.order, payments: [], savings: [], correctionPrefix: 'y', at: day),
      throwsStateError,
    );
    expect(
      () => cancelOrder(
        order('o', status: OrderStatus.selesai),
        payments: [],
        savings: [],
        correctionPrefix: 'z',
        at: day,
      ),
      throwsStateError,
    );
  });
  test('reject mismatched savings ledger', () {
    expect(
      () => cancelOrder(
        order('o'),
        payments: [payment('p', method: PayMethod.tabungan)],
        savings: [],
        correctionPrefix: 'x',
        at: day,
      ),
      throwsStateError,
    );
  });
}
