import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/expenses/state/expense_draft.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_numpad_key.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/organisms/numpad.dart';

class ExpenseAmountSection extends StatelessWidget {
  const ExpenseAmountSection({
    required this.draft,
    required this.onKey,
    super.key,
  });
  final ExpenseDraft draft;
  final ValueChanged<AppNumpadKeyValue> onKey;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.medium,
    children: [
      const SectionHeader(title: 'Jumlah pengeluaran'),
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xxsmall,
          children: [
            const Row(
              children: [
                Expanded(
                  child: AppText(
                    'Nominal (Rp)',
                    variant: AppTextVariant.caption,
                    color: AppColors.ink3,
                  ),
                ),
                AppBadge('Rupiah', variant: AppBadgeVariant.siap),
              ],
            ),
            AppText(
              draft.text.isEmpty ? '0' : Formatters.rupiah(draft.amount),
              key: const ValueKey('expense-nominal'),
              variant: AppTextVariant.figure,
              color: draft.text.isEmpty ? AppColors.placeholder : AppColors.primaryInk,
            ),
            if (draft.nominalError != null)
              AppText(draft.nominalError!, variant: AppTextVariant.caption, color: AppColors.error),
          ],
        ),
      ),
      Numpad(onKey: onKey),
    ],
  );
}
