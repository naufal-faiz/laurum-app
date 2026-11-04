import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/repositories/expense_repository.dart';
import 'package:laurum/core/domain/repositories/order_repository.dart';
import 'package:laurum/core/domain/repositories/report_repository.dart';
import 'package:laurum/core/domain/repositories/savings_repository.dart';
import 'package:laurum/core/domain/savings_entry.dart';

import 'report_mutation_contract.dart';

typedef ReportContractContext = ({
  ReportRepository reports,
  OrderRepository orders,
  ExpenseRepository expenses,
  SavingsRepository savings,
});
typedef ReportContractFactory = Future<ReportContractContext> Function({required bool seeded});

void runReportRepositoryContract(ReportContractFactory factory) {
  runReportMutationContract(factory);
  final week = ReportRange(DateTime(2026, 10, 12), DateTime(2026, 10, 19));
  test('all periods reconcile exclusively to DATA MASTER ledgers', () async {
    final r = (await factory(seeded: true)).reports;
    for (final (range, revenue, count, cost, cash) in [
      (ReportRange(DateTime(2026, 10, 16), DateTime(2026, 10, 17)), 177000, 6, 145000, 130500),
      (week, 589000, 14, 850000, 500000),
      (ReportRange(DateTime(2026, 10), DateTime(2026, 11)), 864000, 16, 1850000, 868500),
    ]) {
      final t = await r.getReport(range);
      expect((t.revenue, t.transactionCount, t.expenses, t.cashIn), (revenue, count, cost, cash));
      expect((t.activeOutstanding, t.savingsBalance), (400500, 430000));
      expect(t.revenue, t.cashFromOrders + t.savingsUsed + t.newOutstanding);
      expect(await r.getReport(ReportRange(range.start, range.end)), t);
    }
    expect(await r.getUnpaidCount(), 5);
    expect(await r.getDailyRevenue(week), [0, 0, 248000, 164000, 177000, 0, 0]);
    final services = await r.getTopServices(week);
    expect(services.map((s) => s.revenue), [301500, 108000, 100000, 59500, 20000]);
    expect(services.fold<int>(0, (sum, s) => sum + s.revenue), 589000);
  });
  test('empty ledgers never fabricate history or a service breakdown', () async {
    final r = (await factory(seeded: false)).reports;
    final t = await r.getReport(week);
    expect(
      (t.revenue, t.expenses, t.cashIn, t.savingsBalance, t.activeOutstanding),
      (0, 0, 0, 0, 0),
    );
    expect(await r.getTopServices(week), isEmpty);
    expect(await r.getUnpaidCount(), 0);
    expect(await r.getDailyRevenue(week), List.filled(7, 0));
  });
  test('old-cohort payment changes flow and global debt without changing weekly revenue', () async {
    final c = await factory(seeded: true);
    final before = await c.reports.getReport(week);
    await c.orders.addPayment(
      Payment(
        id: 'late-payment',
        ownerId: 'owner-001',
        createdAt: week.start,
        orderId: 'ord-0128',
        method: PayMethod.tunai,
        amount: 10000,
        received: 10000,
        paidAt: week.start,
      ),
    );
    final after = await c.reports.getReport(week);
    expect(after.revenue, before.revenue);
    expect(after.newOutstanding, before.newOutstanding);
    expect(after.cashIn, before.cashIn + 10000);
    expect(after.activeOutstanding, before.activeOutstanding - 10000);
  });
  test('UTC savings flow uses exact half-open boundaries and retains global balance', () async {
    final c = await factory(seeded: true);
    for (final (id, at) in [
      ('before', week.end.subtract(const Duration(microseconds: 1))),
      ('end', week.end),
    ]) {
      await c.savings.addEntry(
        SavingsEntry(
          id: 'flow-$id',
          ownerId: 'owner-001',
          createdAt: at.toUtc(),
          customerId: 'cust-001',
          kind: SavingsKind.setor,
          amount: 1,
          method: PayMethod.tunai,
        ),
      );
    }
    final t = await c.reports.getReport(week);
    expect(t.cashIn, 500001);
    expect(t.savingsBalance, 430002);
    expect(t.revenue, 589000);
  });
}
