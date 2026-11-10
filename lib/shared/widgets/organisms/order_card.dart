import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order_rules.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
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
    this.showAction = true,
    this.statusLabel,
    this.paymentLabel,
  }) : assert(total >= 0 && paid >= 0);
  final String orderNo, customerName, summary, timeLabel, detail;
  final String? statusLabel, paymentLabel;
  final int total, paid;
  final OrderStatus status;
  final PayStatus payStatus;
  final bool compact, needsReview, cancelRequested, showAction;
  final VoidCallback? onTap, onAction;
  @override
  Widget build(BuildContext context) {
    final rail = switch ((cancelRequested, needsReview, status)) {
      (true, _, _) => AppCardRail.error,
      (_, true, _) => AppCardRail.warning,
      (_, _, OrderStatus.siap) => AppCardRail.success,
      _ => AppCardRail.info,
    };
    const actions = ['Tandai dijemput', 'Tandai siap', 'Serahkan', null, null];
    final action = status == OrderStatus.siap && (paymentLabel?.startsWith('COD') ?? false)
        ? 'Terima pembayaran'
        : actions[status.index];
    final payment =
        paymentLabel ??
        (payStatus == PayStatus.lunas ? 'Lunas' : 'Sisa ${Formatters.rupiah(total - paid)}');
    final amount = Formatters.rupiah(total);
    final paymentStyle = AppStatusTextVariant.values.byName(payStatus.name);
    return InkWell(
      onTap: onTap,
      child: AppCard(
        rail: rail,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.xsmall,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                AppText(customerName, variant: AppTextVariant.bodyStrong),
                AppBadge(
                  statusLabel ?? orderStatusLabel(status),
                  variant: AppBadgeVariant.values.byName(status.name),
                ),
              ],
            ),
            AppText(summary, variant: AppTextVariant.caption, color: AppColors.ink3),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: AppSpacing.small,
              children: [
                AppText(orderNo, variant: AppTextVariant.monoLabel),
                if (timeLabel.isNotEmpty)
                  AppText(timeLabel, variant: AppTextVariant.monoLabel, color: AppColors.ink3),
                AppStatusText(payment, variant: paymentStyle),
                AppText(amount, variant: AppTextVariant.bodyStrong, color: AppColors.primary),
              ],
            ),
            if (detail.isNotEmpty || (showAction && !compact && action != null))
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: AppSpacing.small,
                runSpacing: AppSpacing.xxsmall,
                children: [
                  if (detail.isNotEmpty)
                    AppText(detail, variant: AppTextVariant.caption, color: AppColors.ink3),
                  if (showAction && !compact && action != null)
                    AppButton(
                      action,
                      variant: AppButtonVariant.action,
                      size: AppButtonSize.small,
                      onPressed: onAction,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
