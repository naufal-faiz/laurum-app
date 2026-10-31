import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/core/domain/expense_category.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/shell/state/shell_state.dart';

class ExpenseDirectory {
  const ExpenseDirectory(this.month, this.categories, this.expenses);
  final DateTime month;
  final List<ExpenseCategory> categories;
  final List<Expense> expenses;
  int get total => expenses.fold(0, (sum, e) => sum + e.amount);
  String category(String id) =>
      categories.where((c) => c.id == id).firstOrNull?.name ?? 'Lain-lain';
  List<Expense> visible(String categoryId) =>
      categoryId.isEmpty ? expenses : expenses.where((e) => e.categoryId == categoryId).toList();
}

final expenseDirectoryProvider = FutureProvider<ExpenseDirectory>((ref) async {
  final now = ref.watch(businessClockProvider)();
  final repo = ref.watch(expenseRepositoryProvider);
  final categories = await repo.getCategories();
  final expenses = await repo.getExpenses(
    from: DateTime(now.year, now.month),
    to: DateTime(now.year, now.month + 1),
  );
  expenses.sort((a, b) => b.spentAt.compareTo(a.spentAt));
  return ExpenseDirectory(DateTime(now.year, now.month), categories, expenses);
});

class ExpenseFilter extends Notifier<String> {
  @override
  String build() => '';
  void select(String id) => state = id;
}

final expenseFilterProvider = NotifierProvider<ExpenseFilter, String>(ExpenseFilter.new);
