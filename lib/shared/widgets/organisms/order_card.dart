import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_status_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    required this.orderNo,
    required this.customerName,
    required this.summary,
    required this.total,
    required this.status,
    required this.payStatus,
    super.key,
    this.timeLabel = '',
    this.detail = '',
    this.paid = 0,
    this.compact = false,
    this.needsReview = false,
    this.cancelRequested = false,
    this.onTap,
    this.onAction,
  }) : assert(total >= 0 && paid >= 0);
  final String orderNo, customerName, summary, timeLabel, detail;
  final int total, paid;
  final OrderStatus status;
  final PayStatus payStatus;
  final bool compact, needsReview, cancelRequested;
  final VoidCallback? onTap, onAction;
  @override
  Widget build(BuildContext context) {
    const labels = ['Menunggu jemput', 'Diproses', 'Siap', 'Selesai', 'Dibatalkan'];
    final label = labels[status.index];
    final action = switch (status) {
      OrderStatus.menungguJemput => 'Tandai dijemput',
      OrderStatus.diproses => 'Tandai siap',
      OrderStatus.siap => 'Serahkan',
      _ => null,
    };
    final payment = switch (payStatus) {
      PayStatus.belumBayar => 'Belum bayar',
      PayStatus.dp => 'DP ${Formatters.rupiah(paid)}',
      PayStatus.lunas => 'Lunas',
    };
    return InkWell(
      onTap: onTap,
      child: AppCard(
        rail:
            AppCardRail.values[cancelRequested
                ? 2
                : needsReview
                ? 1
                : 0],
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
                AppBadge(label, variant: AppBadgeVariant.values.byName(status.name)),
              ],
            ),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                AppText(customerName, variant: AppTextVariant.section),
                AppText(Formatters.rupiah(total), variant: AppTextVariant.section),
              ],
            ),
            AppText(summary, color: AppColors.ink2),
            const AppDivider(),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: AppMoleculeTokens.gap,
              children: [
                AppStatusText(payment, variant: AppStatusTextVariant.values.byName(payStatus.name)),
                if (detail.isNotEmpty)
                  AppText(detail, variant: AppTextVariant.caption, color: AppColors.ink3),
              ],
            ),
            if (!compact && action != null)
              AppButton(action, variant: AppButtonVariant.actionOutline, onPressed: onAction),
          ],
        ),
      ),
    );
  }
}
