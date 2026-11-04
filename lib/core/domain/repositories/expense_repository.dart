import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/core/domain/expense_category.dart';
import 'package:laurum/core/domain/report_range.dart';

abstract class ExpenseRepository {
  Future<List<ExpenseCategory>> getCategories();
  Future<void> saveCategory(ExpenseCategory category);
  // Half-open local date interval [from, to). Deleted rows are excluded.
  Future<List<Expense>> getExpenses({DateTime? from, DateTime? to});
  Future<List<Expense>> getExpensesInRange(ReportRange range);
  Future<void> saveExpense(Expense expense);
  Future<void> deleteExpense(String id);
}
