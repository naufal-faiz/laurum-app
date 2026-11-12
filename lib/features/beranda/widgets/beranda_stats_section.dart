import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/avatar_stack.dart';
import 'package:laurum/shared/widgets/molecules/mini_bar_chart.dart';

/// The two stat cards of frame `LAURUM · Beranda` (165x112 each).
class BerandaStatsSection extends StatelessWidget {
  const BerandaStatsSection({
    required this.savedCustomers,
    required this.newCustomers,
    required this.initials,
    required this.revenue,
    required this.daily,
    this.onRevenue,
    super.key,
  });
  final int savedCustomers, newCustomers;
  final List<String> initials;
  final String revenue;
  final List<int?> daily;
  final VoidCallback? onRevenue;
  @override
  Widget build(BuildContext context) {
    final customerCard = AppCard(
      padding: const EdgeInsets.all(AppSpacing.mediumLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'Pelanggan tersimpan',
            variant: AppTextVariant.caption,
            color: AppColors.ink3,
          ),
          AppText(
            '$savedCustomers',
            variant: AppTextVariant.figure,
            color: AppColors.primaryInk,
          ),
          Wrap(
            spacing: AppSpacing.small,
            runSpacing: AppSpacing.xsmall,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AvatarStack(initials: initials),
              if (newCustomers > 0) AppBadge('+$newCustomers baru', variant: AppBadgeVariant.siap),
            ],
          ),
        ],
      ),
    );
    final revenueCard = AppCard(
      onTap: onRevenue,
      padding: const EdgeInsets.all(AppSpacing.mediumLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'Pendapatan minggu ini',
            variant: AppTextVariant.caption,
            color: AppColors.ink3,
          ),
          AppText(
            revenue,
            variant: AppTextVariant.section,
            color: AppColors.primary,
          ),
          MiniBarChart(amounts: daily),
        ],
      ),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow =
            constraints.maxWidth < 300 || MediaQuery.textScalerOf(context).scale(1) > 1.2;
        if (narrow) {
          return Column(
            spacing: AppSpacing.medium,
            children: [customerCard, revenueCard],
          );
        }
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.medium,
            children: [
              Expanded(child: customerCard),
              Expanded(child: revenueCard),
            ],
          ),
        );
      },
    );
  }
}
