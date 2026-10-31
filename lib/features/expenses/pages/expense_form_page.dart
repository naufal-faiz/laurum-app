import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/expenses/pages/expense_category_sheet.dart';
import 'package:laurum/features/expenses/state/expense_directory.dart';
import 'package:laurum/features/expenses/state/expense_form_controller.dart';
import 'package:laurum/features/expenses/widgets/expense_amount_section.dart';
import 'package:laurum/features/expenses/widgets/expense_details_section.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

class ExpenseFormPage extends ConsumerWidget {
  const ExpenseFormPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(expenseFormProvider);
    final actions = ref.read(expenseFormProvider.notifier);
    final data = ref.watch(expenseDirectoryProvider);
    return FormScaffold(
      title: 'Catat pengeluaran',
      backLabel: 'Kembali',
      onBack: () => context.canPop() ? context.pop() : context.go('/lainnya/pengeluaran'),
      footer: AppButton(
        'Simpan pengeluaran',
        onPressed: draft.valid && data.hasValue
            ? () async {
                if (await actions.save() && context.mounted) {
                  ref.invalidate(expenseFormProvider);
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/lainnya/pengeluaran');
                  }
                }
              }
            : null,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.cardGap,
        children: [
          if (draft.error != null)
            BannerMessage(message: draft.error!, variant: BannerMessageVariant.error),
          ExpenseAmountSection(draft: draft, onNominal: actions.nominal, onKey: actions.key),
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
              onDate: () async {
                final now = ref.read(businessClockProvider)();
                final date = await showDatePicker(
                  context: context,
                  initialDate: draft.date,
                  firstDate: DateTime(2026),
                  lastDate: now,
                  locale: const Locale('id', 'ID'),
                );
                if (date != null) {
                  actions.date(
                    DateTime(date.year, date.month, date.day, draft.date.hour, draft.date.minute),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
