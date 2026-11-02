import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_chip.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';

class PaymentSummarySection extends StatelessWidget {
  const PaymentSummarySection({
    required this.customerName,
    required this.itemCount,
    required this.total,
    required this.term,
    required this.onTerm,
    this.error,
    super.key,
  });
  final String customerName;
  final int itemCount, total;
  final PayTerm term;
  final ValueChanged<PayTerm> onTerm;
  final String? error;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      if (error != null) BannerMessage(message: error!, variant: BannerMessageVariant.error),
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.cardGap,
          children: [
            AppText(customerName, variant: AppTextVariant.section),
            AppText('$itemCount layanan'),
            const AppText('Total tagihan', variant: AppTextVariant.label),
            AppText(Formatters.rupiah(total), variant: AppTextVariant.figure),
            Wrap(
              spacing: AppSpacing.cardGap,
              children: [
                for (final value in PayTerm.values)
                  AppChip(
                    value == PayTerm.sekarang ? 'Bayar sekarang' : 'Bayar nanti (COD)',
                    selected: term == value,
                    onPressed: () => onTerm(value),
                  ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
