import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class ExpenseReportLinkSection extends StatelessWidget {
  const ExpenseReportLinkSection({required this.onOpen, super.key});
  final VoidCallback onOpen;
  @override
  Widget build(BuildContext context) => AppCard(
    onTap: onOpen,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.mediumLarge,
      vertical: AppSpacing.smallMedium,
    ),
    child: const Row(
      spacing: AppSpacing.small,
      children: [
        AppIcon(AppIcons.reports, size: AppDimensions.iconSmall, color: AppColors.primary),
        Expanded(
          child: AppText(
            'Lihat semua pengeluaran di Laporan',
            variant: AppTextVariant.label,
            color: AppColors.primaryInk,
          ),
        ),
        AppText('Buka', variant: AppTextVariant.label, color: AppColors.primary),
        AppIcon(AppIcons.next, size: AppDimensions.iconAction, color: AppColors.primary),
      ],
    ),
  );
}
