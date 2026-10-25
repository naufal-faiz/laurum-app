import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_status_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/info_row.dart';

class OrderSummarySection extends StatelessWidget {
  const OrderSummarySection({required this.data, super.key});
  final OrderDetailData data;

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText('No. nota', variant: AppTextVariant.caption),
                    AppText(order.orderNo, variant: AppTextVariant.titleSub),
                  ],
                ),
              ),
              AppBadge(
                orderStatusLabel(order.status),
                variant: AppBadgeVariant.values.byName(order.status.name),
              ),
            ],
          ),
          AppStatusText(
            data.paymentLabel,
            variant: AppStatusTextVariant.values.byName(data.paymentStatus.name),
          ),
          InfoRow(label: 'Masuk', value: entered),
          InfoRow(label: 'Estimasi siap', value: estimate),
        ],
      ),
    );
  }
}
