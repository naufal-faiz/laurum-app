import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/pages/cash_input_sheet.dart';
import 'package:laurum/features/transactions/pages/checkout_state.dart';
import 'package:laurum/features/transactions/pages/payment_quote.dart';
import 'package:laurum/features/transactions/pages/transaction_draft.dart';
import 'package:laurum/features/transactions/pages/transaction_providers.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_chip.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class PaymentMethodPage extends ConsumerWidget {
  const PaymentMethodPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(transactionDraftProvider);
    final checkout = ref.watch(checkoutControllerProvider);
    final balance = draft.customerId == null
        ? 0
        : ref.watch(customerBalanceProvider(draft.customerId!)).value ?? 0;
    final quote = quotePayment(total: draft.total, balance: balance, state: checkout);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        const SectionHeader(title: 'Metode pembayaran'),
        Wrap(
          spacing: AppSpacing.cardGap,
          children: [
            for (final method in [PayMethod.tunai, PayMethod.qris, PayMethod.transfer])
              AppChip(
                switch (method) {
                  PayMethod.tunai => 'Tunai',
                  PayMethod.qris => 'QRIS',
                  PayMethod.transfer => 'Transfer',
                  PayMethod.tabungan => 'Tabungan',
                },
                selected: checkout.method == method,
                onPressed: () => ref.read(checkoutControllerProvider.notifier).setMethod(method),
              ),
          ],
        ),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.cardGap,
            children: [
              if (checkout.method == PayMethod.tunai)
                MenuRow(
                  label: 'Uang diterima',
                  subtitle: Formatters.rupiah(quote.received),
                  icon: AppIcons.wallet,
                  onTap: () => CashInputSheet.show(context, ref, quote.due, quote.received),
                )
              else
                AppText('Dibayar ${Formatters.rupiah(quote.cashPaid)}'),
              AppText('Sisa bayar ${Formatters.rupiah(quote.due)}', color: AppColors.ink2),
              if (quote.change > 0)
                AppText(
                  'Kembali ${Formatters.rupiah(quote.change)}',
                  variant: AppTextVariant.titleSub,
                  color: AppColors.primary,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
