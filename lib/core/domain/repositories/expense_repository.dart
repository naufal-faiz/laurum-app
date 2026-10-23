import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/core/domain/expense_category.dart';

abstract class ExpenseRepository {
  Future<List<ExpenseCategory>> getCategories();
  Future<List<Expense>> getExpenses({DateTime? from, DateTime? to});
  Future<void> saveExpense(Expense expense);
  Future<void> deleteExpense(String id);
}
