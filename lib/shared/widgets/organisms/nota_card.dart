import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_status_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class NotaCard extends StatelessWidget {
  const NotaCard({
    required this.orderNo,
    required this.customerName,
    required this.summary,
    required this.total,
    required this.status,
    required this.payStatus,
    super.key,
    this.timeLabel = '',
    this.paid = 0,
    this.onTap,
  }) : assert(total >= 0 && paid >= 0);
  final String orderNo, customerName, summary, timeLabel;
  final int total, paid;
  final OrderStatus status;
  final PayStatus payStatus;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    const labels = ['Menunggu jemput', 'Diproses', 'Siap', 'Selesai', 'Dibatalkan'];
    final payment = switch (payStatus) {
      PayStatus.belumBayar => 'Belum bayar',
      PayStatus.dp => 'DP ${Formatters.rupiah(paid)}',
      PayStatus.lunas => 'Lunas',
    };
    return InkWell(
      onTap: onTap,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppMoleculeTokens.gap,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: AppMoleculeTokens.gap,
              children: [
                AppText(orderNo, variant: AppTextVariant.monoLabel),
                if (timeLabel.isNotEmpty)
                  AppText(timeLabel, variant: AppTextVariant.monoLabel, color: AppColors.ink3),
              ],
            ),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: AppMoleculeTokens.gap,
              children: [
                AppText(customerName, variant: AppTextVariant.section),
                AppText(Formatters.rupiah(total), variant: AppTextVariant.section),
              ],
            ),
            AppText(summary, color: AppColors.ink2),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: AppMoleculeTokens.gap,
              children: [
                AppBadge(labels[status.index], variant: AppBadgeVariant.values.byName(status.name)),
                AppStatusText(payment, variant: AppStatusTextVariant.values.byName(payStatus.name)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
