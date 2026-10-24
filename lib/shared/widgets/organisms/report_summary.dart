import 'package:flutter/material.dart';
import 'package:laurum/core/domain/report_totals.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppMoleculeTokens.gap,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppMoleculeTokens.labelGap,
            children: [
              const AppText(
                'Estimasi laba bersih',
                variant: AppTextVariant.label,
                color: AppColors.ink2,
              ),
              AppText(Formatters.rupiah(totals.profit), variant: AppTextVariant.figure),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: const BoxDecoration(
                  color: AppColors.chipIdle,
                  borderRadius: AppRadius.input,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppMoleculeTokens.smallGap,
                  children: [
                    AppText(
                      'Pendapatan ${Formatters.rupiah(totals.revenue)} · '
                      '${totals.transactionCount} transaksi',
                      variant: AppTextVariant.label,
                      color: AppColors.primary,
                    ),
                    AppText(
                      'Pengeluaran ${Formatters.rupiah(totals.expenses)} · $expenseSummary',
                      variant: AppTextVariant.label,
                      color: AppColors.errorInk,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppMoleculeTokens.labelGap,
            children: [
              AppText(
                'Kas masuk ${Formatters.rupiah(totals.cashIn)}\n'
                'Tunai, QRIS, transfer; termasuk setoran tabungan',
                variant: AppTextVariant.bodyStrong,
              ),
              AppText(
                'Tabungan pelanggan ${Formatters.rupiah(totals.savingsBalance)}\n'
                'Titipan, bukan omzet',
                variant: AppTextVariant.bodyStrong,
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onOutstandingTap,
          child: AppCard(
            child: Row(
              children: [
                Expanded(
                  child: AppText(
                    'Piutang aktif ${Formatters.rupiah(totals.activeOutstanding)}\n'
                    '$unpaidCount nota belum lunas',
                    variant: AppTextVariant.section,
                    color: AppColors.error,
                  ),
                ),
                const AppIcon(AppIcons.next),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
