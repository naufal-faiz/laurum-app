import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/repository_providers.dart';

final expenseDeleteProvider =
    NotifierProvider.family<ExpenseDeleteController, AsyncValue<void>, String>(
      ExpenseDeleteController.new,
    );

class ExpenseDeleteController extends Notifier<AsyncValue<void>> {
  ExpenseDeleteController(this.id);
  final String id;
  @override
  AsyncValue<void> build() => const AsyncData(null);
  Future<bool> delete() async {
    if (state.isLoading) return false;
    state = const AsyncLoading();
    try {
      await ref.read(expenseRepositoryProvider).deleteExpense(id);
      state = const AsyncData(null);
      return true;
    } catch (error, stack) {
      state = AsyncError(error, stack);
      return false;
    }
  }
}
