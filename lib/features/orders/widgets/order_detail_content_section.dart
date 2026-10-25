import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/pages/payment_record_sheet.dart';
import 'package:laurum/features/orders/state/order_detail_controller.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/orders/widgets/order_detail_body_section.dart';
import 'package:laurum/features/transactions/state/receipt_print_controller.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';

class OrderDetailContentSection extends ConsumerWidget {
  const OrderDetailContentSection({required this.orderId, super.key});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(orderDetailProvider(orderId));
    final actions = ref.watch(orderActionsProvider);
    final printing = ref.watch(receiptPrintProvider);
    return snapshot.when(
      loading: () => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.cardGap,
        children: [for (var i = 0; i < 5; i++) const AppSkeleton()],
      ),
      error: (_, _) => EmptyState(
        title: 'Gagal memuat order',
        icon: AppIcons.alert,
        actionLabel: 'Coba lagi',
        onAction: () => ref.invalidate(orderDetailProvider(orderId)),
      ),
      data: (data) => data == null
          ? const EmptyState(title: 'Order tidak ditemukan', icon: AppIcons.receipt)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.screenPadding,
              children: [
                if (actions.error != null)
                  BannerMessage(
                    message: actions.error!,
                    variant: BannerMessageVariant.error,
                  ),
                if (printing.error != null)
                  BannerMessage(
                    message: printing.error!,
                    variant: BannerMessageVariant.error,
                  ),
                if (printing.notice != null) BannerMessage(message: printing.notice!),
                OrderDetailBodySection(
                  data: data,
                  onWhatsApp: () => ref
                      .read(externalLauncherProvider)
                      .launchWhatsApp(
                        phone: data.customer.phone,
                        message:
                            'Halo ${data.customer.name}, pesanan ${data.order.orderNo} '
                            'berstatus ${orderStatusLabel(data.order.status)}.',
                      ),
                  onRecord: () => PaymentRecordSheet.show(context, ref, data),
                ),
              ],
            ),
    );
  }
}
