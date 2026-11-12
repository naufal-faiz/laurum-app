import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/state/transaction_line.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/selection_tile.dart';

class PaymentSummarySection extends StatelessWidget {
  const PaymentSummarySection({
    required this.customerName,
    required this.itemCount,
    required this.total,
    required this.term,
    required this.onTerm,
    this.lines = const [],
    this.discount = 0,
    this.error,
    super.key,
  });
  final String customerName;
  final int itemCount, total, discount;
  final List<DraftLine> lines;
  final PayTerm term;
  final ValueChanged<PayTerm> onTerm;
  final String? error;
  @override
  Widget build(BuildContext context) {
    final weightGrams = lines
        .where((line) => line.service.kind == ServiceKind.kiloan)
        .fold(0, (sum, line) => sum + line.qtyMilli);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        if (error != null) BannerMessage(message: error!, variant: BannerMessageVariant.error),
        AppCard(
          style: AppCardStyle.primary,
          bubble: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.xxsmall,
            children: [
              const AppText(
                'Total tagihan',
                variant: AppTextVariant.label,
                color: AppColors.heroTagline,
              ),
              AppText(
                Formatters.rupiah(total),
                variant: AppTextVariant.figure,
                color: AppColors.onPrimary,
                semanticsLabel: 'Tagihan $customerName ${Formatters.rupiah(total)}',
              ),
              AppText(
                '$itemCount layanan · ${Formatters.berat(weightGrams)} · diskon ${Formatters.rupiah(discount)}',
                variant: AppTextVariant.caption,
                color: AppColors.heroTagline,
              ),
            ],
          ),
        ),
        Row(
          spacing: AppSpacing.cardGap,
          children: [
            for (final value in PayTerm.values)
              Expanded(
                child: SelectionTile(
                  label: value == PayTerm.sekarang ? 'Bayar sekarang' : 'Bayar nanti (COD)',
                  selected: term == value,
                  onPressed: () => onTerm(value),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
