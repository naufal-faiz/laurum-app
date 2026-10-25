import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/payment_quote.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/features/transactions/state/transaction_providers.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_chip.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';

class PaymentSummarySection extends ConsumerWidget {
  const PaymentSummarySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(transactionDraftProvider);
    final checkout = ref.watch(checkoutControllerProvider);
    final customer = ref
        .watch(customerCatalogProvider)
        .value
        ?.where((c) => c.id == draft.customerId)
        .firstOrNull;
    final balance = customer == null
        ? 0
        : ref.watch(customerBalanceProvider(customer.id)).value ?? 0;
    final quote = quotePayment(total: draft.total, balance: balance, state: checkout);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        if (checkout.error != null)
          BannerMessage(message: checkout.error!, variant: BannerMessageVariant.error),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.cardGap,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(customer?.name ?? 'Pelanggan', variant: AppTextVariant.section),
                        AppText('${draft.itemCount} layanan'),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const AppText('Total tagihan', variant: AppTextVariant.label),
                      AppText(Formatters.rupiah(draft.total), variant: AppTextVariant.figure),
                    ],
                  ),
                ],
              ),
              const AppDivider(),
              Wrap(
                spacing: AppSpacing.cardGap,
                children: [
                  for (final mode in PaymentMode.values)
                    AppChip(
                      switch (mode) {
                        PaymentMode.lunas => 'Lunas',
                        PaymentMode.dp => 'DP',
                        PaymentMode.belumBayar => 'Belum bayar',
                      },
                      selected: checkout.mode == mode,
                      onPressed: () => ref
                          .read(checkoutControllerProvider.notifier)
                          .setMode(mode, due: quote.due),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
