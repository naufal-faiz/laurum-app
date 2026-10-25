import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/payment_quote.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/features/transactions/state/transaction_providers.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_switch.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class PaymentSavingsSection extends ConsumerWidget {
  const PaymentSavingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(transactionDraftProvider);
    final checkout = ref.watch(checkoutControllerProvider);
    final customerId = draft.customerId;
    if (customerId == null) return const SizedBox.shrink();
    final balance = ref.watch(customerBalanceProvider(customerId)).value ?? 0;
    final quote = quotePayment(total: draft.total, balance: balance, state: checkout);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.cardGap,
        children: [
          Row(
            children: [
              const Expanded(
                child: AppText('Tabungan pelanggan', variant: AppTextVariant.bodyStrong),
              ),
              if (balance > 0)
                AppSwitch(
                  value: checkout.useSavings,
                  label: 'Pakai tabungan',
                  onChanged: (bool value) {
                    final used = value ? (balance < draft.total ? balance : draft.total) : 0;
                    ref
                        .read(checkoutControllerProvider.notifier)
                        .setSavings(value: value, due: draft.total - used);
                  },
                ),
            ],
          ),
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
}
