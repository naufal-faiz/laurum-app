import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';

class PaymentChangeSection extends StatelessWidget {
  const PaymentChangeSection({
    required this.amount,
    required this.saveExcess,
    required this.onExcess,
    super.key,
  });
  final int amount;
  final bool saveExcess;
  final ValueChanged<bool> onExcess;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      AppCard(
        style: AppCardStyle.success,
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AppText(
                saveExcess ? 'Simpan ke tabungan' : 'Kembalian',
                color: AppColors.successInk,
                variant: AppTextVariant.label,
              ),
            ),
            Flexible(
              child: AppText(
                Formatters.rupiah(amount),
                variant: AppTextVariant.label,
                color: AppColors.successInk,
              ),
            ),
          ],
        ),
      ),
      ChipBar(
        labels: const ['Kembalian', 'Simpan ke tabungan'],
        selectedIndex: saveExcess ? 1 : 0,
        onSelected: (i) => onExcess(i == 1),
      ),
    ],
  );
}
