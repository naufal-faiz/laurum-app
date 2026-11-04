import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';

class ReceiptActionsSection extends StatelessWidget {
  const ReceiptActionsSection({
    required this.busy,
    required this.onPrint,
    required this.onWhatsApp,
    required this.onHome,
    required this.onOrder,
    this.onRecord,
    super.key,
  });
  final bool busy;
  final VoidCallback onPrint, onWhatsApp, onHome, onOrder;
  final VoidCallback? onRecord;
  @override
  Widget build(BuildContext context) {
    final largeText = MediaQuery.textScalerOf(context).scale(1) > 1.3;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        if (onRecord != null && largeText)
          AppButton('Catat pembayaran', onPressed: busy ? null : onRecord),
        Row(
          spacing: AppSpacing.cardGap,
          children: [
            if (onRecord != null && !largeText)
              Expanded(
                flex: 3,
                child: AppButton('Catat pembayaran', onPressed: busy ? null : onRecord),
              ),
            Expanded(
              flex: 2,
              child: AppButton(
                'WhatsApp',
                variant: onRecord == null ? AppButtonVariant.cta : AppButtonVariant.secondary,
                onPressed: busy ? null : onWhatsApp,
              ),
            ),
            AppIconButton(AppIcons.printer, label: 'Cetak struk', onPressed: busy ? null : onPrint),
          ],
        ),
        if (largeText) ...[
          AppButton(
            'Lihat detail',
            variant: AppButtonVariant.actionOutline,
            onPressed: busy ? null : onOrder,
          ),
          AppButton(
            'Ke beranda',
            variant: AppButtonVariant.actionOutline,
            onPressed: busy ? null : onHome,
          ),
        ] else
          Row(
            spacing: AppSpacing.cardGap,
            children: [
              Expanded(
                flex: 3,
                child: AppButton(
                  'Lihat detail',
                  variant: AppButtonVariant.actionOutline,
                  onPressed: busy ? null : onOrder,
                ),
              ),
              Expanded(
                flex: 2,
                child: AppButton(
                  'Ke beranda',
                  variant: AppButtonVariant.actionOutline,
                  onPressed: busy ? null : onHome,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
