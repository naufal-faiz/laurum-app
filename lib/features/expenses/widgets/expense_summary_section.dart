import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class ExpenseSummarySection extends StatelessWidget {
  const ExpenseSummarySection({
    required this.month,
    required this.count,
    required this.total,
    required this.breakdown,
    super.key,
  });
  final String month;
  final int count, total;
  final Map<String, int> breakdown;

  @override
  Widget build(BuildContext context) {
    final top = breakdown.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final largest = top.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(month, variant: AppTextVariant.label, color: AppColors.ink3),
        const SizedBox(height: AppSpacing.small),
        AppCard(
          style: AppCardStyle.primary,
          bubble: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xxsmall,
            children: [
              const AppText(
                'Total pengeluaran bulan ini',
                variant: AppTextVariant.caption,
                color: AppColors.heroTagline,
              ),
              AppText(
                Formatters.rupiah(total),
                variant: AppTextVariant.figure,
                color: AppColors.onPrimary,
              ),
              AppText(
                '$count transaksi',
                variant: AppTextVariant.caption,
                color: AppColors.heroTagline,
              ),
            ],
          ),
        ),
        if (largest.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.cardGap),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.medium,
              children: [
                for (final entry in largest)
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.all(AppSpacing.medium),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppSpacing.xxsmall,
                        children: [
                          AppText(
                            entry.key,
                            variant: AppTextVariant.caption,
                            color: AppColors.ink3,
                          ),
                          AppText(
                            Formatters.rupiah(entry.value),
                            variant: AppTextVariant.label,
                            color: AppColors.primaryInk,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
