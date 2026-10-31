import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/expenses/state/expense_delete_controller.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';
import 'package:laurum/shared/widgets/organisms/confirm_modal.dart';
import 'package:laurum/shared/widgets/templates/sheet_scaffold.dart';

class ExpenseDetailSheet extends ConsumerWidget {
  const ExpenseDetailSheet({required this.expense, required this.category, super.key});
  final Expense expense;
  final String category;
  static Future<void> show(BuildContext context, Expense expense, String category) =>
      AppBottomSheet.show<void>(
        context: context,
        title: 'Detail pengeluaran',
        child: ExpenseDetailSheet(expense: expense, category: category),
      );
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final action = ref.watch(expenseDeleteProvider(expense.id));
    return SheetScaffold(
      footer: AppButton(
        'Hapus',
        variant: AppButtonVariant.destructiveOutline,
        icon: AppIcons.delete,
        onPressed: action.isLoading
            ? null
            : () async {
                final confirmed = await ConfirmModal.show(
                  context: context,
                  title: 'Hapus pengeluaran ini?',
                  message: 'Pengeluaran akan dihapus dari daftar dan Laporan.',
                  confirmLabel: 'Hapus',
                  destructive: true,
                  icon: AppIcons.delete,
                );
                if (confirmed == true && context.mounted) {
                  final removed = await ref
                      .read(expenseDeleteProvider(expense.id).notifier)
                      .delete();
                  if (removed && context.mounted) Navigator.of(context).pop();
                }
              },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.cardGap,
        children: [
          if (action.hasError)
            const BannerMessage(
              message: 'Pengeluaran gagal dihapus. Coba lagi.',
              variant: BannerMessageVariant.error,
            ),
          AppText(category, variant: AppTextVariant.section),
          AppText(Formatters.rupiah(expense.amount), variant: AppTextVariant.figure),
          AppText('${Formatters.tanggal(expense.spentAt)} ${Formatters.jam(expense.spentAt)}'),
          if (expense.vendor.isNotEmpty) AppText(expense.vendor),
          if (expense.note.isNotEmpty) AppText(expense.note),
          if (expense.photoPath != null) const AppText('Foto struk dilampirkan'),
        ],
      ),
    );
  }
}
