import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/features/transactions/widgets/payment_method_section.dart';
import 'package:laurum/features/transactions/widgets/payment_savings_section.dart';
import 'package:laurum/features/transactions/widgets/payment_summary_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

class PaymentPage extends ConsumerWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(transactionDraftProvider);
    final ready = draft.customerId != null && draft.lines.isNotEmpty;
    return FormScaffold(
      title: 'Pembayaran',
      backLabel: 'Kembali',
      onBack: () => context.pop(),
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.cardGap,
        children: [
          AppButton(
            'Simpan dan cetak',
            onPressed: ready ? () => _save(context, ref) : null,
          ),
          AppButton(
            'Simpan saja',
            variant: AppButtonVariant.secondary,
            onPressed: ready ? () => _save(context, ref) : null,
          ),
        ],
      ),
      body: ready
          ? const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.screenPadding,
              children: [PaymentSummarySection(), PaymentSavingsSection(), PaymentMethodSection()],
            )
          : Center(
              child: EmptyState(
                title: 'Nota belum lengkap',
                icon: AppIcons.receipt,
                description: 'Pilih pelanggan dan layanan terlebih dahulu.',
                actionLabel: 'Kembali ke transaksi',
                onAction: () => context.pop(),
              ),
            ),
    );
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final orderId = await ref.read(checkoutControllerProvider.notifier).save();
    if (orderId != null && context.mounted) context.go('/transaksi/nota/$orderId');
  }
}
