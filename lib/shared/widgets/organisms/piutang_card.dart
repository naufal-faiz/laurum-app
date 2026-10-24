import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_status_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class PiutangCard extends StatelessWidget {
  const PiutangCard({
    required this.customerName,
    required this.orderNo,
    required this.summary,
    required this.total,
    required this.paid,
    required this.ageLabel,
    super.key,
    this.dateLabel = '',
    this.onPay,
    this.onRemind,
  }) : assert(total > 0 && paid >= 0 && paid < total);
  final String customerName, orderNo, summary, ageLabel, dateLabel;
  final int total, paid;
  final VoidCallback? onPay, onRemind;
  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppMoleculeTokens.gap,
      children: [
        AppText(customerName, variant: AppTextVariant.section),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: AppMoleculeTokens.gap,
          children: [
            AppText(orderNo, variant: AppTextVariant.monoLabel),
            if (dateLabel.isNotEmpty) AppText(dateLabel, variant: AppTextVariant.caption),
            AppText(ageLabel, variant: AppTextVariant.caption, color: AppColors.ink3),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: AppMoleculeTokens.gap,
          children: [
            AppText(summary, color: AppColors.ink2),
            AppText(Formatters.rupiah(total)),
          ],
        ),
        AppStatusText(
          paid == 0 ? 'Belum bayar' : 'DP ${Formatters.rupiah(paid)}',
          variant: paid == 0 ? AppStatusTextVariant.belumBayar : AppStatusTextVariant.dp,
        ),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: AppMoleculeTokens.gap,
          children: [
            const AppText('Sisa tagihan', color: AppColors.ink2),
            AppText(Formatters.rupiah(total - paid), variant: AppTextVariant.section),
          ],
        ),
        Row(
          spacing: AppMoleculeTokens.gap,
          children: [
            Expanded(
              child: AppButton('Catat bayar', variant: AppButtonVariant.action, onPressed: onPay),
            ),
            Expanded(
              child: AppButton(
                'Ingatkan',
                variant: AppButtonVariant.actionOutline,
                onPressed: onRemind,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
