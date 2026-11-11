import 'package:flutter/material.dart';
import 'package:laurum/core/domain/order_rules.dart' as policy;
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/info_row.dart';
import 'package:laurum/shared/widgets/molecules/payment_badge.dart';

class OrderSummarySection extends StatelessWidget {
  const OrderSummarySection({required this.data, this.useOrderStatus = true, super.key});
  final OrderDetailData data;
  final bool useOrderStatus;

  @override
  Widget build(BuildContext context) {
    final order = data.order;
    final entered = '${Formatters.tanggal(order.enteredAt)} ${Formatters.jam(order.enteredAt)}';
    final estimate =
        '${Formatters.tanggal(order.estimatedAt)} ${Formatters.jam(order.estimatedAt)}';
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.cardGap,
        children: [
          const AppText('No. nota', variant: AppTextVariant.caption, color: AppColors.ink3),
          Wrap(
            spacing: AppSpacing.cardGap,
            runSpacing: AppSpacing.cardGap,
            alignment: WrapAlignment.spaceBetween,
            children: [
              AppText(order.orderNo, variant: AppTextVariant.titleSub, color: AppColors.primary),
              PaymentBadge(label: data.paymentLabel, status: data.paymentStatus),
              AppBadge(
                policy.orderStatusLabel(order.status, useOrderStatus: useOrderStatus),
                variant: AppBadgeVariant.values.byName(order.status.name),
              ),
            ],
          ),
          InfoRow(label: 'Masuk', value: entered, compact: true),
          InfoRow(label: 'Estimasi siap', value: estimate, compact: true),
        ],
      ),
    );
  }
}
