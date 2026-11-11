import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class TransactionFooterSection extends StatelessWidget {
  const TransactionFooterSection({
    required this.total,
    required this.itemCount,
    required this.onPay,
    super.key,
  });
  final int total, itemCount;
  final VoidCallback? onPay;
  @override
  Widget build(BuildContext context) => Row(
    spacing: AppSpacing.small,
    children: [
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'Total tagihan ($itemCount item)',
              variant: AppTextVariant.caption,
              color: AppColors.ink3,
            ),
            AppText(
              Formatters.rupiah(total),
              variant: AppTextVariant.figure,
              color: AppColors.primaryInk,
            ),
          ],
        ),
      ),
      Expanded(child: AppButton('Bayar', onPressed: onPay)),
    ],
  );
}
