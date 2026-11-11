import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/info_row.dart';
import 'package:laurum/shared/widgets/molecules/inline_link.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class TransactionSummarySection extends StatelessWidget {
  const TransactionSummarySection({
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.onDiscount,
    super.key,
  });
  final int subtotal, discount, total;
  final VoidCallback onDiscount;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.small,
    children: [
      const SectionHeader(title: 'Ringkasan', titleColor: AppColors.primaryInk),
      AppCard(
        child: Column(
          spacing: AppSpacing.medium,
          children: [
            InfoRow(label: 'Subtotal', value: Formatters.rupiah(subtotal), compact: true),
            const AppDivider(),
            Row(
              spacing: AppSpacing.small,
              children: [
                const Expanded(child: AppText('Diskon', color: AppColors.ink3)),
                Flexible(
                  child: AppText(Formatters.rupiah(discount), variant: AppTextVariant.caption),
                ),
                InlineLink('Atur diskon', onTap: onDiscount),
              ],
            ),
            const AppDivider(),
            Row(
              spacing: AppSpacing.small,
              children: [
                const Expanded(child: AppText('Total', variant: AppTextVariant.bodyStrong)),
                Flexible(
                  child: AppText(
                    Formatters.rupiah(total),
                    variant: AppTextVariant.section,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
