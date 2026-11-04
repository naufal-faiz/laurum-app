import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/core/services/id_generator_provider.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/expenses/state/expense_draft.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/shared/widgets/atoms/app_numpad_key.dart';

final expenseFormProvider = NotifierProvider<ExpenseFormController, ExpenseDraft>(
  ExpenseFormController.new,
);

class ExpenseFormController extends Notifier<ExpenseDraft> {
  @override
  ExpenseDraft build() => ExpenseDraft(date: ref.read(businessClockProvider)());
  void category(String id) => state = state.copyWith(categoryId: id);
  void vendor(String value) => state = state.copyWith(vendor: value);
  void note(String value) => state = state.copyWith(note: value);
  void date(DateTime value) => state = state.copyWith(date: value);
  void nominal(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '').replaceFirst(RegExp('^0+'), '');
    state = state.copyWith(text: digits.substring(0, digits.length.clamp(0, 12)), fresh: true);
  }

  void key(AppNumpadKeyValue key) {
    if (state.busy || key == AppNumpadKeyValue.decimal) return;
    final text = state.fresh ? '' : state.text;
    nominal(
      key == AppNumpadKeyValue.backspace
          ? (text.isEmpty ? '' : text.substring(0, text.length - 1))
          : '$text${key.label}',
    );
    state = state.copyWith(fresh: false);
  }

  Future<void> photo() async {
    if (state.busy) return;
    try {
      final path = await ref.read(photoPickerProvider).pickPhoto();
      state = state.copyWith(photoPath: path);
    } catch (_) {
      state = state.copyWith(error: 'Foto gagal dilampirkan. Coba lagi.');
    }
  }

  Future<bool> save() async {
    if (!state.valid) return false;
    final draft = state;
    state = state.copyWith(busy: true);
    try {
      final now = ref.read(businessClockProvider)();
      await ref
          .read(expenseRepositoryProvider)
          .saveExpense(
            Expense(
              id: ref.read(idGeneratorProvider).newId(),
              ownerId: ref.read(authServiceProvider).currentUserId ?? 'owner',
              createdAt: now,
              categoryId: draft.categoryId,
              amount: draft.amount,
              spentAt: draft.date,
              vendor: draft.vendor.trim(),
              note: draft.note.trim(),
              photoPath: draft.photoPath,
            ),
          );
      state = state.copyWith(busy: false);
      return true;
    } catch (_) {
      state = state.copyWith(busy: false, error: 'Pengeluaran gagal disimpan. Coba lagi.');
      return false;
    }
  }
}
