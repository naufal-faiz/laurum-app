import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/core/domain/expense_category.dart';
import 'package:laurum/core/domain/repositories/expense_repository.dart';
import 'package:laurum/core/services/transaction_runner.dart';
import 'package:laurum/features/expenses/data/expense_fixtures.dart';

class InMemoryExpenseRepository extends Notifier<List<Expense>>
    implements ExpenseRepository, TransactionParticipant {
  @override
  void Function() checkpoint() {
    final expenses = state, categories = List.of(_categories);
    return () {
      _categories = categories;
      state = expenses;
    };
  }

  void clearLocalData() {
    _categories = [];
    state = const [];
  }

  List<ExpenseCategory> _categories = List.of(expenseCategoryFixtures);
  @override
  List<Expense> build() => List.unmodifiable(expenseFixtures);

  @override
  Future<List<ExpenseCategory>> getCategories() async => List.unmodifiable(_categories);

  @override
  Future<void> saveCategory(ExpenseCategory category) async {
    _categories = [..._categories.where((c) => c.id != category.id), category];
    ref.notifyListeners();
  }

  @override
  Future<List<Expense>> getExpenses({DateTime? from, DateTime? to}) async {
    return state.where((e) {
      if (e.deletedAt != null) return false;
      if (from != null && e.spentAt.isBefore(from)) return false;
      if (to != null && !e.spentAt.isBefore(to)) return false;
      return true;
    }).toList();
  }

  @override
  Future<void> saveExpense(Expense expense) async {
    final idx = state.indexWhere((e) => e.id == expense.id);
    if (idx >= 0) {
      state = List.unmodifiable([
        for (var i = 0; i < state.length; i++)
          if (i == idx) expense else state[i],
      ]);
    } else {
      state = List.unmodifiable([...state, expense]);
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    state = List.unmodifiable([
      for (final e in state)
        if (e.id == id)
          Expense(
            id: e.id,
            ownerId: e.ownerId,
            createdAt: e.createdAt,
            categoryId: e.categoryId,
            amount: e.amount,
            spentAt: e.spentAt,
            vendor: e.vendor,
            note: e.note,
            photoPath: e.photoPath,
            updatedAt: e.updatedAt,
            deletedAt: DateTime.now(),
          )
        else
          e,
    ]);
  }
}

final inMemoryExpenseRepositoryProvider =
    NotifierProvider<InMemoryExpenseRepository, List<Expense>>(
      InMemoryExpenseRepository.new,
    );
