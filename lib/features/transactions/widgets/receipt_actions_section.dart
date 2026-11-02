import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

class ReceiptActionsSection extends StatelessWidget {
  const ReceiptActionsSection({
    required this.busy,
    required this.onPrint,
    required this.onWhatsApp,
    required this.onNew,
    required this.onOrder,
    this.onRecord,
    super.key,
  });
  final bool busy;
  final VoidCallback onPrint, onWhatsApp, onNew, onOrder;
  final VoidCallback? onRecord;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      if (onRecord != null) AppButton('Catat pembayaran', onPressed: busy ? null : onRecord),
      AppButton('Cetak struk', icon: AppIcons.printer, onPressed: busy ? null : onPrint),
      AppButton(
        'Kirim lewat WhatsApp',
        variant: AppButtonVariant.secondary,
        icon: AppIcons.chat,
        onPressed: busy ? null : onWhatsApp,
      ),
      Row(
        spacing: AppSpacing.cardGap,
        children: [
          Expanded(
            child: AppButton(
              'Transaksi baru',
              variant: AppButtonVariant.actionOutline,
              onPressed: onNew,
            ),
          ),
          Expanded(
            child: AppButton(
              'Lihat order',
              variant: AppButtonVariant.actionOutline,
              onPressed: onOrder,
            ),
          ),
        ],
      ),
    ],
  );
}
