import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/core/domain/report.dart';
import 'package:laurum/core/domain/report_baseline.dart';
import 'package:laurum/core/domain/report_range.dart';

import 'domain_samples.dart';

void main() {
  final range = ReportRange(DateTime(2026, 10, 12), DateTime(2026, 10, 19));
  test('period flows differ from current balances and revenue cohort', () {
    final result = buildReport(
      baseline: ReportBaseline(range: range),
      orders: [
        order('o'),
        order('old', total: 80, enteredAt: DateTime(2026, 10)),
        order('cancel', total: 90, status: OrderStatus.dibatalkan),
        order('end', total: 70, enteredAt: DateTime(2026, 10, 19)),
      ],
      payments: [
        payment('cash', amount: 30),
        payment('saved', amount: 20, method: PayMethod.tabungan),
        payment('old', orderId: 'old', amount: 10),
        payment('refund', orderId: 'cancel', amount: -5),
        payment('outside', orderId: 'old', amount: 5, paidAt: DateTime(2026, 10, 19)),
      ],
      expenses: [
        Expense(
          id: 'e',
          ownerId: 'owner',
          createdAt: day,
          categoryId: 'x',
          amount: 15,
          spentAt: day,
        ),
      ],
      savings: [
        saving('d', amount: 200, createdAt: DateTime(2026, 10)),
        saving('new', amount: 40),
        saving('use', amount: 20, kind: SavingsKind.pakai),
      ],
      range: range,
    );
    expect(result.revenue, 100);
    expect(result.transactionCount, 1);
    expect(result.expenses, 15);
    expect(result.profit, 85);
    expect(result.cashIn, 75);
    expect(result.activeOutstanding, 185);
    expect(result.savingsBalance, 220);
    expect(result.cashFromOrders, 30);
    expect(result.savingsUsed, 20);
    expect(result.newOutstanding, 50);
    expect(result.revenue, result.cashFromOrders + result.savingsUsed + result.newOutstanding);
  });
  test('overpayment is cash flow but reconciliation caps applied payment', () {
    final result = buildReport(
      baseline: ReportBaseline(range: range),
      orders: [order('o')],
      payments: [payment('p', amount: 150)],
      expenses: [],
      savings: [],
      range: range,
    );
    expect(result.cashIn, 150);
    expect(result.cashFromOrders, 100);
    expect(result.newOutstanding, 0);
    expect(result.activeOutstanding, 0);
  });
  test('range is start inclusive and end exclusive, WIB only', () {
    expect(range.contains(DateTime(2026, 10, 12)), isTrue);
    expect(range.contains(DateTime(2026, 10, 19)), isFalse);
    expect(() => ReportRange(DateTime.utc(2026), DateTime.utc(2027)), throwsArgumentError);
    expect(() => ReportRange(day, day), throwsArgumentError);
  });
}
