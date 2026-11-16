import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/expenses/pages/expense_category_sheet.dart';
import 'package:laurum/features/expenses/pages/expense_date_flow.dart';
import 'package:laurum/features/expenses/state/expense_directory.dart';
import 'package:laurum/features/expenses/state/expense_form_controller.dart';
import 'package:laurum/features/expenses/widgets/expense_amount_section.dart';
import 'package:laurum/features/expenses/widgets/expense_details_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_sub.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

class ExpenseFormPage extends ConsumerWidget {
  const ExpenseFormPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(expenseFormProvider);
    final actions = ref.read(expenseFormProvider.notifier);
    final data = ref.watch(expenseDirectoryProvider);
    void close() => context.canPop() ? context.pop() : context.go('/lainnya/pengeluaran');
    return FormScaffold(
      title: 'Catat pengeluaran',
      backLabel: 'Kembali',
      subtitle: 'Pengeluaran baru · ${Formatters.tanggalStruk(draft.date)}',
      appBarVariant: AppBarSubVariant.detail,
      onBack: close,
      footer: LayoutBuilder(
        builder: (context, constraints) {
          final cancel = AppButton(
            'Batal',
            size: AppButtonSize.large,
            variant: AppButtonVariant.actionOutline,
            onPressed: draft.busy ? null : close,
          );
          final save = AppButton(
            'Simpan pengeluaran',
            icon: AppIcons.check,
            size: AppButtonSize.large,
            busy: draft.busy,
            onPressed: draft.valid && data.hasValue
                ? () async {
                    if (await actions.save() && context.mounted) {
                      ref.invalidate(expenseFormProvider);
                      close();
                    }
                  }
                : null,
          );
          final stacked =
              constraints.maxWidth < AppSpacing.touchTarget * 6 ||
              MediaQuery.textScalerOf(context).scale(1) > 1.2;
          return stacked
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSpacing.small,
                  children: [save, cancel],
                )
              : Row(
                  spacing: AppSpacing.medium,
                  children: [
                    Expanded(flex: 3, child: cancel),
                    Expanded(flex: 5, child: save),
                  ],
                );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.cardGap,
        children: [
          if (draft.error != null)
            BannerMessage(message: draft.error!, variant: BannerMessageVariant.error),
          ExpenseAmountSection(draft: draft, onKey: actions.key),
          data.when(
            loading: () => const AppText('Memuat kategori...'),
            error: (_, _) =>
                AppButton('Coba lagi', onPressed: () => ref.invalidate(expenseDirectoryProvider)),
            data: (value) => ExpenseDetailsSection(
              draft: draft,
              categories: value.categories,
              onCategory: actions.category,
              onNewCategory: () => ExpenseCategorySheet.show(context, ref),
              onVendor: actions.vendor,
              onNote: actions.note,
              onPhoto: actions.photo,
              onDate: () => showExpenseDatePicker(context, ref),
            ),
          ),
        ],
      ),
    );
  }
}
