import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/state/payment_quote.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_switch.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class PaymentSavingsSection extends StatelessWidget {
  const PaymentSavingsSection({
    required this.balance,
    required this.quote,
    required this.useSavings,
    required this.onChanged,
    super.key,
  });
  final int balance;
  final PaymentQuote quote;
  final bool useSavings;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        const AppText('Tabungan pelanggan', variant: AppTextVariant.bodyStrong),
        if (balance > 0)
          AppSwitch(value: useSavings, label: 'Pakai tabungan', onChanged: onChanged),
        AppText('Saldo: ${Formatters.rupiah(balance)}', color: AppColors.primary),
        if (quote.savingsUsed > 0) ...[
          AppText(
            'Tabungan dipakai -${Formatters.rupiah(quote.savingsUsed)}',
            color: AppColors.primary,
          ),
          AppText('Sisa bayar ${Formatters.rupiah(quote.due)}'),
          AppText(
            'Sisa tabungan ${Formatters.rupiah(balance - quote.savingsUsed)}',
            variant: AppTextVariant.caption,
          ),
        ] else if (balance == 0)
          const AppText('Tidak ada saldo tabungan.', color: AppColors.ink3),
      ],
    ),
  );
}
