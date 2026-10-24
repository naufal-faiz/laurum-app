import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/pages/order_detail_data.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';

enum OrderMenuAction { edit, advance, cancel }

class OrderMenuSheet extends StatelessWidget {
  const OrderMenuSheet({required this.data, super.key});
  final OrderDetailData data;

  static Future<OrderMenuAction?> show(BuildContext context, OrderDetailData data) =>
      AppBottomSheet.show<OrderMenuAction>(
        context: context,
        title: 'Order ${data.order.orderNo}',
        subtitle: 'Pilih tindakan untuk nota ini.',
        child: OrderMenuSheet(data: data),
      );

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              MenuRow(
                label: 'Edit order',
                subtitle: 'Ubah layanan, berat, diskon, dan catatan',
                icon: AppIcons.receipt,
                onTap: () => Navigator.of(context).pop(OrderMenuAction.edit),
              ),
              MenuRow(
                label: 'Ubah status',
                subtitle: nextStatusLabel(data.order.status),
                icon: AppIcons.refresh,
                onTap: () => Navigator.of(context).pop(OrderMenuAction.advance),
              ),
            ],
          ),
        ),
        AppButton(
          'Batalkan order',
          variant: AppButtonVariant.destructiveOutline,
          icon: AppIcons.delete,
          onPressed: () => Navigator.of(context).pop(OrderMenuAction.cancel),
        ),
      ],
    ),
  );
}
