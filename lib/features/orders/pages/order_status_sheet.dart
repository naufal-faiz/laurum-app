import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/pages/order_detail_controller.dart';
import 'package:laurum/features/orders/pages/order_detail_data.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';

class OrderStatusSheet extends ConsumerWidget {
  const OrderStatusSheet({required this.data, super.key});
  final OrderDetailData data;

  static Future<void> show(BuildContext context, OrderDetailData data) => AppBottomSheet.show<void>(
    context: context,
    title: 'Ubah status',
    subtitle: 'Status order berjalan berurutan.',
    child: OrderStatusSheet(data: data),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.watch(orderActionsProvider);
    final busy = actions.pending.contains(data.order.id);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.cardGap,
        children: [
          if (actions.error != null)
            BannerMessage(message: actions.error!, variant: BannerMessageVariant.error),
          AppCard(
            padding: EdgeInsets.zero,
            child: MenuRow(
              label: nextStatusLabel(data.order.status),
              subtitle: 'Dari ${orderStatusLabel(data.order.status)}',
              icon: AppIcons.check,
              onTap: busy
                  ? null
                  : () async {
                      final ok = await ref.read(orderActionsProvider.notifier).advance(data.order);
                      if (ok && context.mounted) Navigator.of(context).pop();
                    },
            ),
          ),
          const AppText(
            'Status hanya dapat maju satu langkah. Untuk membatalkan nota, pakai menu Batalkan order.',
            variant: AppTextVariant.caption,
          ),
        ],
      ),
    );
  }
}
