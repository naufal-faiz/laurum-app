import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/cancellation.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/domain/report.dart';
import 'package:laurum/core/domain/report_baseline.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/savings_rules.dart';

import 'domain_samples.dart';

void main() {
  test('mixed settlement then cancellation reconciles all ledgers and report', () {
    final original = order('o');
    final deposit = saving('deposit');
    final used = applySavings(
      original,
      payments: [],
      savings: [deposit],
      amount: 40,
      paymentId: 'used-payment',
      savingsId: 'used-savings',
      at: day,
    );
    final payments = [used.payment, payment('cash', amount: 60, received: 100)];
    final savings = [deposit, used.savings];
    expect(outstanding([original], payments), 0);
    final cancelled = cancelOrder(
      original,
      payments: payments,
      savings: savings,
      correctionPrefix: 'cancel',
      at: day,
    );
    final range = ReportRange(DateTime(2026, 10), DateTime(2026, 11));
    final report = buildReport(
      baseline: ReportBaseline(range: range),
      orders: [cancelled.order],
      payments: [...payments, ...cancelled.payments],
      expenses: [],
      savings: [...savings, ...cancelled.savings],
      range: range,
    );
    expect(report.revenue, 0);
    expect(report.transactionCount, 0);
    expect(report.activeOutstanding, 0);
    expect(report.savingsBalance, 100);
    expect(report.cashIn, 100); // Deposit remains; cash payment and refund cancel.
  });
  test('integer allocation rounds a half rupiah correctly at a large magnitude', () {
    expect(lineTotal(qtyMilli: 1000000001, unitPrice: 1000001), 1000001001000);
    expect(() => lineTotal(qtyMilli: 9007199254740991, unitPrice: 1001), throwsRangeError);
  });
}
