import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/state/order_edit_controller.dart';
import 'package:laurum/features/orders/widgets/order_edit_body_section.dart';
import 'package:laurum/features/transactions/pages/transaction_leave_flow.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/features/transactions/widgets/transaction_details_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';
import 'package:laurum/shared/widgets/templates/sub_scaffold.dart';

class OrderEditPage extends ConsumerWidget {
  const OrderEditPage({required this.orderId, super.key});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(orderEditProvider(orderId));
    final draft = ref.watch(transactionDraftProvider);
    final state = snapshot.value;
    if (snapshot.hasError) {
      return SubScaffold(
        title: 'Edit order',
        backLabel: 'Kembali',
        onBack: () => context.canPop() ? context.pop() : context.go('/antrean'),
        body: const Center(
          child: AppText(
            'Nota selesai atau dibatalkan tidak dapat diedit.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (state == null) {
      return SubScaffold(
        title: 'Edit order',
        backLabel: 'Kembali',
        onBack: () => context.pop(),
        body: const Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            spacing: AppSpacing.cardGap,
            children: [AppSkeleton(), AppSkeleton(), AppSkeleton()],
          ),
        ),
      );
    }
    return FormScaffold(
      title: 'Edit order ${state.order.orderNo}',
      backLabel: 'Kembali',
      onBack: () => leaveTransaction(context, ref),
      summary: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText('Total tagihan (${draft.itemCount} item)', variant: AppTextVariant.label),
          AppText(Formatters.rupiah(draft.total), variant: AppTextVariant.figure),
        ],
      ),
      footer: AppButton(
        'Simpan perubahan',
        onPressed: state.saving || draft.lines.isEmpty
            ? null
            : () async {
                final ok = await ref.read(orderEditProvider(orderId).notifier).save();
                if (ok && context.mounted) {
                  context.pop();
                  ref.read(transactionDraftProvider.notifier).clear();
                }
              },
      ),
      body: OrderEditBodySection(
        orderId: orderId,
        order: state.order,
        error: state.error,
        details: const TransactionDetailsSection(),
      ),
    );
  }
}
