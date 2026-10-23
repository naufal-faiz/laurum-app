import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/report.dart';
import 'package:laurum/core/domain/report_baseline.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/report_totals.dart';

import 'domain_samples.dart';

void main() {
  final range = ReportRange(DateTime(2026, 10, 12), DateTime(2026, 10, 19));
  test('baseline adds history once and rejects mismatched period', () {
    final baseline = ReportBaseline(
      range: range,
      totals: const ReportTotals(
        revenue: 1000,
        transactionCount: 10,
        expenses: 200,
        cashIn: 800,
        activeOutstanding: 300,
        savingsBalance: 400,
        cashFromOrders: 700,
        savingsUsed: 100,
        newOutstanding: 200,
      ),
    );
    final result = buildReport(
      baseline: baseline,
      orders: [order('o')],
      payments: [],
      expenses: [],
      savings: [],
      range: range,
    );
    expect(result.revenue, 1100);
    expect(result.transactionCount, 11);
    expect(result.activeOutstanding, 400);
    expect(result.profit, 900);
    expect(result.savingsBalance, 400);
    expect(
      () => buildReport(
        baseline: baseline,
        orders: [],
        payments: [],
        expenses: [],
        savings: [],
        range: ReportRange(DateTime(2026, 11), DateTime(2026, 12)),
      ),
      throwsArgumentError,
    );
  });
}
