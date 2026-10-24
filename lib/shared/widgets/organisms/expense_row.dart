import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class ExpenseRow extends StatelessWidget {
  const ExpenseRow({
    required this.category,
    required this.note,
    required this.amount,
    required this.timeLabel,
    super.key,
    this.vendor = '',
    this.onTap,
  }) : assert(amount >= 0);
  final String category, note, timeLabel, vendor;
  final int amount;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppMoleculeTokens.gap,
              children: [
                Wrap(
                  spacing: AppMoleculeTokens.gap,
                  children: [
                    AppText(category, variant: AppTextVariant.label, color: AppColors.primary),
                    AppText(timeLabel, variant: AppTextVariant.monoLabel, color: AppColors.ink3),
                  ],
                ),
                AppText(note, variant: AppTextVariant.bodyStrong),
                if (vendor.isNotEmpty)
                  AppText(vendor, variant: AppTextVariant.caption, color: AppColors.ink3),
              ],
            ),
          ),
          const SizedBox(width: AppMoleculeTokens.gap),
          AppText(
            Formatters.rupiah(-amount),
            variant: AppTextVariant.section,
            textAlign: TextAlign.end,
            color: AppColors.error,
          ),
        ],
      ),
    ),
  );
}
