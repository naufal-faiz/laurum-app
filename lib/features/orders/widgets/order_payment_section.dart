import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/payment_badge.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class OrderPaymentSection extends StatelessWidget {
  const OrderPaymentSection({required this.data, required this.onRecord, super.key});
  final OrderDetailData data;
  final VoidCallback? onRecord;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      const SectionHeader(title: 'Pembayaran', titleColor: AppColors.primaryInk),
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.cardGap,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.small,
              runSpacing: AppSpacing.small,
              children: [
                PaymentBadge(label: data.paymentLabel, status: data.paymentStatus),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText(
                      'Terbayar',
                      variant: AppTextVariant.caption,
                      color: AppColors.ink3,
                    ),
                    AppText(Formatters.rupiah(data.paid), variant: AppTextVariant.bodyStrong),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText(
                      'Sisa piutang',
                      variant: AppTextVariant.caption,
                      color: AppColors.ink3,
                    ),
                    AppText(
                      Formatters.rupiah(data.outstanding),
                      variant: AppTextVariant.bodyStrong,
                      color: data.outstanding == 0 ? AppColors.successInk : AppColors.errorInk,
                    ),
                  ],
                ),
              ],
            ),
            if (data.canRecord)
              AppButton(
                'Catat pembayaran',
                variant: AppButtonVariant.actionOutline,
                onPressed: data.outstanding <= 0 ? null : onRecord,
              ),
          ],
        ),
      ),
    ],
  );
}
