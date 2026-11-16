import 'package:flutter/material.dart';
import 'package:laurum/core/domain/report_totals.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/stat_tile.dart';

class ReportSummary extends StatelessWidget {
  const ReportSummary({
    required this.totals,
    required this.expenseSummary,
    required this.unpaidCount,
    super.key,
    this.onOutstandingTap,
  });
  final ReportTotals totals;
  final String expenseSummary;
  final int unpaidCount;
  final VoidCallback? onOutstandingTap;
  @override
  Widget build(BuildContext context) {
    const title = 'Estimasi laba bersih';
    final transactions = '${totals.transactionCount} transaksi';
    final income = 'Masuk ${Formatters.rupiah(totals.revenue)}';
    final expense = 'Keluar ${Formatters.rupiah(totals.expenses)}';
    final positions = [
      StatTile(
        label: 'Kas masuk',
        value: Formatters.rupiah(totals.cashIn),
        compact: true,
        description:
            'Kas termasuk setoran\n'
            'Tabungan ${Formatters.rupiah(totals.savingsBalance)}\nTitipan, bukan omzet',
      ),
      StatTile(
        label: 'Piutang aktif',
        value: Formatters.rupiah(totals.activeOutstanding),
        description: '$unpaidCount nota belum lunas',
        valueColor: AppColors.error,
        compact: true,
        onTap: onOutstandingTap,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.mediumLarge,
      children: [
        AppCard(
          style: AppCardStyle.primary,
          bubble: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.small,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: AppSpacing.small,
                runSpacing: AppSpacing.small,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const AppText(title, variant: AppTextVariant.label, color: AppColors.onPrimary),
                  AppBadge(transactions, variant: AppBadgeVariant.diproses),
                ],
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: AppText(
                  Formatters.rupiah(totals.profit),
                  variant: AppTextVariant.figure,
                  color: AppColors.onPrimary,
                ),
              ),
              Wrap(
                spacing: AppSpacing.small,
                runSpacing: AppSpacing.small,
                children: [
                  AppBadge(income, variant: AppBadgeVariant.diproses, color: AppColors.successInk),
                  AppBadge(expense, variant: AppBadgeVariant.diproses, color: AppColors.errorInk),
                ],
              ),
              AppText(expenseSummary, variant: AppTextVariant.caption, color: AppColors.onPrimary),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) =>
              constraints.maxWidth < AppSpacing.touchTarget * 6 ||
                  MediaQuery.textScalerOf(context).scale(1) > 1.2
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSpacing.smallMedium,
                  children: positions,
                )
              : IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: AppSpacing.smallMedium,
                    children: [for (final tile in positions) Expanded(child: tile)],
                  ),
                ),
        ),
      ],
    );
  }
}
