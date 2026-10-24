import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/features/orders/pages/order_cancel.dart';
import 'package:laurum/features/orders/pages/order_detail_content_page.dart';
import 'package:laurum/features/orders/pages/order_detail_controller.dart';
import 'package:laurum/features/orders/pages/order_detail_data.dart';
import 'package:laurum/features/orders/pages/order_detail_footer_page.dart';
import 'package:laurum/features/orders/pages/order_menu_sheet.dart';
import 'package:laurum/features/orders/pages/order_status_sheet.dart';
import 'package:laurum/features/transactions/pages/receipt_print_controller.dart';
import 'package:laurum/features/transactions/pages/receipt_view.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

class OrderDetailPage extends ConsumerWidget {
  const OrderDetailPage({required this.orderId, super.key});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(orderDetailProvider(orderId)).value;
    final busy = ref.watch(orderActionsProvider).pending.contains(orderId);
    return FormScaffold(
      title: 'Detail order',
      backLabel: 'Kembali',
      onBack: () => context.canPop() ? context.pop() : context.go('/antrean'),
      trailing: AppIconButton(
        AppIcons.more,
        label: 'Menu order',
        color: AppColors.ink,
        onPressed: data == null || data.isFinal || busy ? null : () => _menu(context, ref, data),
      ),
      footer: data == null
          ? const SizedBox.shrink()
          : OrderDetailFooterPage(
              data: data,
              busy: busy,
              onPrint: () => _print(ref, data),
              onAdvance: () => ref.read(orderActionsProvider.notifier).advance(data.order),
            ),
      body: OrderDetailContentPage(orderId: orderId),
    );
  }

  Future<void> _print(WidgetRef ref, OrderDetailData data) async {
    final view = await ref.read(receiptViewProvider(data.order.id).future);
    if (view == null) return;
    await ref.read(receiptPrintProvider.notifier).printReceipt(view);
  }

  Future<void> _menu(BuildContext context, WidgetRef ref, OrderDetailData data) async {
    final action = await OrderMenuSheet.show(context, data);
    if (!context.mounted) return;
    switch (action) {
      case OrderMenuAction.edit:
        await context.push('/order/${data.order.id}/edit');
      case OrderMenuAction.advance:
        await OrderStatusSheet.show(context, data);
      case OrderMenuAction.cancel:
        await confirmCancelOrder(context, ref, data);
      case null:
        break;
    }
  }
}
