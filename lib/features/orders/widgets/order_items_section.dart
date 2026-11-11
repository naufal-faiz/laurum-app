import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/info_row.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class OrderItemsSection extends StatelessWidget {
  const OrderItemsSection({required this.data, super.key});
  final OrderDetailData data;

  @override
  Widget build(BuildContext context) {
    final order = data.order;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        SectionHeader(
          title: 'Rincian cucian',
          titleColor: AppColors.primaryInk,
          trailing: AppText(
            '${data.items.length} layanan',
            variant: AppTextVariant.caption,
            color: AppColors.ink3,
          ),
        ),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.cardGap,
            children: [
              for (final item in data.items) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(item.serviceName, variant: AppTextVariant.bodyStrong),
                          AppText(
                            '${orderQuantityLabel(item)} × ${Formatters.rupiah(item.unitPrice)}',
                            variant: AppTextVariant.caption,
                            color: AppColors.ink2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.cardGap),
                    AppText(
                      Formatters.rupiah(item.lineTotal),
                      variant: AppTextVariant.bodyStrong,
                      color: AppColors.primaryInk,
                    ),
                  ],
                ),
                const AppDivider(),
              ],
              InfoRow(label: 'Subtotal', value: Formatters.rupiah(order.subtotal), compact: true),
              if (order.discount > 0)
                InfoRow(
                  label: 'Diskon',
                  value: '-${Formatters.rupiah(order.discount)}',
                  compact: true,
                ),
              Row(
                spacing: AppSpacing.small,
                children: [
                  const Expanded(
                    child: AppText('Total tagihan', variant: AppTextVariant.bodyStrong),
                  ),
                  Flexible(
                    child: AppText(
                      Formatters.rupiah(order.total),
                      variant: AppTextVariant.section,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (order.note.trim().isNotEmpty)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.cardGap,
              children: [
                const AppText('Catatan cucian:', variant: AppTextVariant.label),
                AppText('“${order.note}”', variant: AppTextVariant.caption, color: AppColors.ink2),
              ],
            ),
          ),
      ],
    );
  }
}
