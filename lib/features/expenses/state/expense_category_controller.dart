import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/expense_category.dart';
import 'package:laurum/core/services/id_generator_provider.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/expenses/state/expense_form_controller.dart';
import 'package:laurum/features/shell/state/shell_state.dart';

typedef ExpenseCategoryDraft = ({String name, String? error, bool busy});
final expenseCategoryProvider = NotifierProvider<ExpenseCategoryController, ExpenseCategoryDraft>(
  ExpenseCategoryController.new,
);

class ExpenseCategoryController extends Notifier<ExpenseCategoryDraft> {
  @override
  ExpenseCategoryDraft build() => (name: '', error: null, busy: false);
  void name(String value) => state = (name: value, error: null, busy: false);
  Future<bool> save() async {
    if (state.busy) return false;
    final name = state.name.trim();
    if (name.isEmpty) {
      state = (name: state.name, error: 'Nama kategori wajib diisi.', busy: false);
      return false;
    }
    state = (name: name, error: null, busy: true);
    try {
      final repo = ref.read(expenseRepositoryProvider);
      final all = await repo.getCategories();
      if (all.any((c) => c.name.toLowerCase() == name.toLowerCase())) {
        state = (name: name, error: 'Kategori sudah ada.', busy: false);
        return false;
      }
      final now = ref.read(businessClockProvider)();
      final category = ExpenseCategory(
        id: ref.read(idGeneratorProvider).newId(),
        ownerId: ref.read(authServiceProvider).currentUserId ?? 'owner',
        createdAt: now,
        name: name,
      );
      await repo.saveCategory(category);
      ref.read(expenseFormProvider.notifier).category(category.id);
      state = (name: name, error: null, busy: false);
      return true;
    } catch (_) {
      state = (name: name, error: 'Kategori gagal disimpan. Coba lagi.', busy: false);
      return false;
    }
  }
}
