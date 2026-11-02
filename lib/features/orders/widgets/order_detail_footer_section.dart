import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

class OrderDetailFooterSection extends StatelessWidget {
  const OrderDetailFooterSection({
    required this.data,
    required this.busy,
    required this.onPrint,
    required this.onAdvance,
    this.useOrderStatus = true,
    this.allowWithoutPrint = false,
    this.onEdit,
    this.onDelete,
    this.onComplete,
    this.onWithoutPrint,
    this.onPayment,
    super.key,
  });
  final OrderDetailData data;
  final bool busy;
  final VoidCallback onPrint;
  final VoidCallback onAdvance;
  final bool useOrderStatus, allowWithoutPrint;
  final VoidCallback? onEdit, onDelete, onComplete, onWithoutPrint, onPayment;
  @override
  Widget build(BuildContext context) => !useOrderStatus && !data.isFinal
      ? Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.cardGap,
          children: [
            Row(
              spacing: AppSpacing.cardGap,
              children: [
                Expanded(
                  child: AppButton(
                    'Edit',
                    variant: AppButtonVariant.actionOutline,
                    onPressed: busy ? null : onEdit,
                  ),
                ),
                Expanded(
                  child: AppButton(
                    'Hapus',
                    variant: AppButtonVariant.actionOutline,
                    onPressed: busy ? null : onDelete,
                  ),
                ),
              ],
            ),
            if (data.completionHeld)
              AppButton(
                'Cetak struk',
                variant: AppButtonVariant.actionOutline,
                onPressed: busy ? null : onPrint,
              ),
            AppButton(
              data.completionHeld ? 'Terima pembayaran' : 'Selesaikan',
              onPressed: busy
                  ? null
                  : data.completionHeld
                  ? onPayment
                  : onComplete,
            ),
            if (allowWithoutPrint && !data.completionHeld)
              AppButton(
                'Selesaikan tanpa cetak',
                variant: AppButtonVariant.actionOutline,
                onPressed: busy ? null : onWithoutPrint,
              ),
          ],
        )
      : Row(
          spacing: AppSpacing.cardGap,
          children: [
            Expanded(
              child: AppButton(
                'Cetak struk',
                variant: AppButtonVariant.actionOutline,
                icon: AppIcons.printer,
                onPressed: busy ? null : onPrint,
              ),
            ),
            if (!data.isFinal)
              Expanded(
                child: AppButton(
                  data.completionHeld && data.order.status == OrderStatus.siap
                      ? 'Terima pembayaran'
                      : nextStatusLabel(data.order.status),
                  onPressed: busy
                      ? null
                      : data.completionHeld && data.order.status == OrderStatus.siap
                      ? onPayment
                      : onAdvance,
                ),
              ),
          ],
        );
}
