import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/cancellation.dart';
import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/core/domain/report_range.dart';

import 'report_contract.dart';

void runReportMutationContract(ReportContractFactory factory) {
  final range = ReportRange(DateTime(2026, 10, 12), DateTime(2026, 10, 19));
  test('cancellation removes revenue and reverses cash without changing current savings', () async {
    final c = await factory(seeded: true);
    final order = (await c.orders.getOrderById('ord-0139'))!;
    final result = cancelOrder(
      order,
      payments: await c.orders.getPaymentsByOrderId(order.id),
      savings: await c.savings.getAllEntries(),
      correctionPrefix: 'contract-cancel',
      at: DateTime(2026, 10, 16),
    );
    expect(result.savings, isEmpty);
    await c.orders.saveOrder(result.order, payments: result.payments, events: [result.event]);
    final t = await c.reports.getReport(range);
    expect((t.revenue, t.transactionCount, t.cashIn), (564000, 13, 475000));
    expect((t.activeOutstanding, t.savingsBalance), (400500, 430000));
    expect(
      (await c.reports.getTopServices(range)).fold<int>(0, (n, s) => n + s.revenue),
      t.revenue,
    );
  });
  test('expense edit and removal affect every matching period consistently', () async {
    final c = await factory(seeded: true);
    final old = (await c.expenses.getExpenses()).first;
    await c.expenses.saveExpense(
      Expense(
        id: old.id,
        ownerId: old.ownerId,
        createdAt: old.createdAt,
        categoryId: old.categoryId,
        amount: old.amount + 100,
        spentAt: old.spentAt,
        vendor: old.vendor,
        note: old.note,
        photoPath: old.photoPath,
      ),
    );
    expect((await c.reports.getReport(range)).expenses, 850100);
    await c.expenses.deleteExpense(old.id);
    expect((await c.reports.getReport(range)).expenses, 850000 - old.amount);
    expect((await c.reports.getReport(range)).revenue, 589000);
  });
}
