import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/pages/order_detail_data.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

class OrderDetailFooterPage extends StatelessWidget {
  const OrderDetailFooterPage({
    required this.data,
    required this.busy,
    required this.onPrint,
    required this.onAdvance,
    super.key,
  });
  final OrderDetailData data;
  final bool busy;
  final VoidCallback onPrint;
  final VoidCallback onAdvance;

  @override
  Widget build(BuildContext context) => Row(
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
            nextStatusLabel(data.order.status),
            onPressed: busy ? null : onAdvance,
          ),
        ),
    ],
  );
}
