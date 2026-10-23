import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/savings_rules.dart';

import 'domain_samples.dart';

void main() {
  test('balance uses debit magnitudes and signed adjustments', () {
    final ledger = [
      saving('a'),
      saving('b', amount: 40, kind: SavingsKind.pakai),
      saving('c', amount: -5, kind: SavingsKind.penyesuaian),
      saving('other', customerId: 'x', amount: 900),
    ];
    expect(savingsBalance(ledger, customerId: 'c'), 55);
  });
  test('apply savings returns immutable linked entries, no input mutation', () {
    final deposits = [saving('a')];
    final result = applySavings(
      order('o', total: 90),
      payments: [],
      savings: deposits,
      amount: 60,
      paymentId: 'p',
      savingsId: 's',
      at: day,
    );
    expect(result.payment.method, PayMethod.tabungan);
    expect(result.payment.amount, 60);
    expect(result.savings.kind, SavingsKind.pakai);
    expect(result.savings.orderId, 'o');
    expect(savingsBalance([...deposits, result.savings]), 40);
    expect(deposits.length, 1);
  });
  test('reject insufficient balance, excess payment, zero and duplicate IDs', () {
    for (final amount in [0, -1, 51]) {
      expect(
        () => applySavings(
          order('o'),
          payments: [],
          savings: [saving('a', amount: 50)],
          amount: amount,
          paymentId: 'p',
          savingsId: 's',
          at: day,
        ),
        throwsArgumentError,
      );
    }
    expect(
      () => applySavings(
        order('o', total: 40),
        payments: [payment('p', amount: 30)],
        savings: [saving('a')],
        amount: 11,
        paymentId: 'q',
        savingsId: 's',
        at: day,
      ),
      throwsArgumentError,
    );
    expect(
      () => applySavings(
        order('o'),
        payments: [],
        savings: [saving('s')],
        amount: 10,
        paymentId: 'p',
        savingsId: 's',
        at: day,
      ),
      throwsArgumentError,
    );
    expect(
      () => applySavings(
        order('o', status: OrderStatus.dibatalkan),
        payments: [],
        savings: [saving('a')],
        amount: 10,
        paymentId: 'p',
        savingsId: 's',
        at: day,
      ),
      throwsStateError,
    );
  });
}
