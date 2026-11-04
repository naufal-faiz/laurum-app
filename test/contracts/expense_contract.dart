import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/core/domain/expense_category.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/repositories/expense_repository.dart';

import '../domain_samples.dart';
import 'repository_factory.dart';

Expense contractExpense(String id, DateTime at, {int amount = 100}) => Expense(
  id: id,
  ownerId: 'owner',
  createdAt: day,
  categoryId: 'cat',
  amount: amount,
  spentAt: at,
);

void runExpenseRepositoryContract(RepositoryFactory<ExpenseRepository> factory) {
  late ExpenseRepository repo;
  setUp(() async => repo = await factory());
  test('category and expense upsert, soft delete', () async {
    expect(await repo.getExpenses(), isEmpty);
    final category = ExpenseCategory(id: 'cat', ownerId: 'owner', createdAt: day, name: 'Sabun');
    await repo.saveCategory(category);
    await repo.saveCategory(category);
    expect(await repo.getCategories(), [category]);
    await repo.saveExpense(contractExpense('a', day));
    final changed = contractExpense('a', day, amount: 200);
    await repo.saveExpense(changed);
    expect(await repo.getExpenses(), [changed]);
    await repo.deleteExpense('a');
    expect(await repo.getExpenses(), isEmpty);
  });
  test('range includes start, excludes end and deleted rows', () async {
    final range = ReportRange(day, day.add(const Duration(days: 1)));
    for (final (id, at) in [
      ('before', day.subtract(const Duration(seconds: 1))),
      ('start', day),
      ('end', range.end),
      ('deleted', day),
    ]) {
      await repo.saveExpense(contractExpense(id, at));
    }
    await repo.deleteExpense('deleted');
    expect((await repo.getExpensesInRange(range)).map((e) => e.id), ['start']);
    expect(await repo.getExpensesInRange(range), await repo.getExpenses(from: day, to: range.end));
  });
}
