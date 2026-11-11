import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/pages/cash_input_sheet.dart';
import 'package:laurum/features/transactions/pages/payment_flow.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/payment_quote.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/features/transactions/state/transaction_providers.dart';
import 'package:laurum/features/transactions/widgets/payment_method_section.dart';
import 'package:laurum/features/transactions/widgets/payment_savings_section.dart';
import 'package:laurum/features/transactions/widgets/payment_summary_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_sub.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

class PaymentPage extends ConsumerWidget {
  const PaymentPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(transactionDraftProvider);
    final checkout = ref.watch(checkoutControllerProvider);
    final controller = ref.read(checkoutControllerProvider.notifier);
    final customers = ref.watch(customerCatalogProvider);
    final customer = customers.value?.where((c) => c.id == draft.customerId).firstOrNull;
    final balance = draft.customerId == null
        ? null
        : ref.watch(customerBalanceProvider(draft.customerId!)).value;
    final ready = customer != null && draft.lines.isNotEmpty && balance != null;
    final quote = quotePayment(total: draft.total, balance: balance ?? 0, state: checkout);
    final enabled = ready && quote.valid && !checkout.saving;
    return FormScaffold(
      title: 'Pembayaran',
      backLabel: 'Kembali',
      appBarVariant: AppBarSubVariant.detail,
      subtitle: customer?.name,
      onBack: () => context.pop(),
      footer: Row(
        spacing: AppSpacing.cardGap,
        children: [
          Expanded(
            child: AppButton(
              'Kembali',
              variant: AppButtonVariant.secondary,
              size: AppButtonSize.large,
              onPressed: enabled ? () => finishCheckout(context, ref, receipt: false) : null,
            ),
          ),
          Expanded(
            flex: 2,
            child: AppButton(
              'Konfirmasi pembayaran',
              onPressed: enabled ? () => finishCheckout(context, ref, receipt: true) : null,
            ),
          ),
        ],
      ),
      body: ready
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.screenPadding,
              children: [
                PaymentSummarySection(
                  customerName: customer.name,
                  itemCount: draft.itemCount,
                  total: draft.total,
                  term: checkout.payTerm,
                  onTerm: controller.setTerm,
                  error: checkout.error,
                ),
                PaymentSavingsSection(
                  balance: balance,
                  quote: quote,
                  useSavings: checkout.useSavings,
                  onChanged: (value) => controller.setSavings(value: value),
                ),
                PaymentMethodSection(
                  checkout: checkout,
                  quote: quote,
                  onMethod: controller.setMethod,
                  onAmount: () => CashInputSheet.show(context, ref, quote.due, quote.received),
                  onExcess: (save) => controller.setExcess(save: save),
                ),
              ],
            )
          : EmptyState(
              title: 'Nota belum lengkap',
              icon: AppIcons.receipt,
              description: 'Pilih pelanggan dan layanan terlebih dahulu.',
              actionLabel: 'Kembali ke transaksi',
              onAction: () => context.pop(),
            ),
    );
  }
}
