import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/domain/order_rules.dart' as policy;
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/features/orders/pages/order_cancel_flow.dart';
import 'package:laurum/features/orders/pages/order_completion_flow.dart';
import 'package:laurum/features/orders/pages/order_detail_menu_flow.dart';
import 'package:laurum/features/orders/pages/payment_record_sheet.dart';
import 'package:laurum/features/orders/state/order_completion_controller.dart';
import 'package:laurum/features/orders/state/order_detail_controller.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/orders/widgets/order_detail_content_section.dart';
import 'package:laurum/features/orders/widgets/order_detail_footer_section.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/features/transactions/state/receipt_print_controller.dart';
import 'package:laurum/features/transactions/state/receipt_view.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

class OrderDetailPage extends ConsumerWidget {
  const OrderDetailPage({required this.orderId, super.key});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(orderDetailProvider(orderId));
    final data = snapshot.value;
    final actions = ref.watch(orderActionsProvider);
    final printing = ref.watch(receiptPrintProvider);
    final completion = ref.watch(orderCompletionProvider(orderId));
    final profile = ref.watch(businessProfileProvider).value;
    final useStatus = profile?.useOrderStatus ?? true;
    final busy =
        actions.pending.contains(orderId) ||
        completion.busy ||
        printing.printing ||
        profile == null;
    return FormScaffold(
      title: 'Detail order',
      backLabel: 'Kembali',
      onBack: () => context.canPop() ? context.pop() : context.go('/antrean'),
      trailing: !useStatus
          ? null
          : AppIconButton(
              AppIcons.more,
              label: 'Menu order',
              color: AppColors.ink,
              onPressed: data == null || data.isFinal || busy
                  ? null
                  : () => showOrderDetailMenu(context, ref, data),
            ),
      footer: data == null
          ? const SizedBox.shrink()
          : OrderDetailFooterSection(
              data: data,
              busy: busy,
              useOrderStatus: useStatus,
              allowWithoutPrint: completion.allowWithoutPrint,
              onPrint: () => _print(ref),
              onAdvance: () => ref.read(orderActionsProvider.notifier).advance(data.order),
              onEdit: () => context.push('/order/$orderId/edit'),
              onDelete: () => confirmCancelOrder(context, ref, data, simplified: true),
              onComplete: () => confirmCompleteOrder(context, ref, orderId),
              onWithoutPrint: () => confirmCompleteWithoutPrint(context, ref, orderId),
            ),
      body: OrderDetailContentSection(
        data: data,
        loading: snapshot.isLoading,
        failed: snapshot.hasError,
        useOrderStatus: useStatus,
        error: completion.error ?? actions.error ?? printing.error,
        notice: completion.error == null ? printing.notice : null,
        onRetry: () => ref.invalidate(orderDetailProvider(orderId)),
        onWhatsApp: () {
          if (data == null) return;
          ref
              .read(externalLauncherProvider)
              .launchWhatsApp(
                phone: data.customer.phone,
                message:
                    'Halo ${data.customer.name}, pesanan ${data.order.orderNo} '
                    'berstatus ${policy.orderStatusLabel(data.order.status, useOrderStatus: useStatus)}.',
              );
        },
        onRecord: () {
          if (data != null) PaymentRecordSheet.show(context, ref, data);
        },
      ),
    );
  }

  Future<void> _print(WidgetRef ref) async {
    ref.invalidate(receiptViewProvider(orderId));
    final view = await ref.read(receiptViewProvider(orderId).future);
    if (view != null) await ref.read(receiptPrintProvider.notifier).printReceipt(view);
  }
}
