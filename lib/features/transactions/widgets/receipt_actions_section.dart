import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/core/theme/app_text_styles.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

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
    final scaler = MediaQuery.textScalerOf(context);
    final largeText = scaler.scale(1) > 1.3;
    final textHeight =
        scaler.scale(AppTextStyles.bodyStrong.fontSize!) * AppTextStyles.bodyStrong.height! * 2;
    final height = textHeight > AppSpacing.touchTarget ? textHeight : AppSpacing.touchTarget;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = largeText
            ? constraints.maxWidth
            : (constraints.maxWidth - AppSpacing.cardGap) / 2;
        return Wrap(
          spacing: AppSpacing.cardGap,
          runSpacing: AppSpacing.cardGap,
          children: [
            for (final action in <Widget>[
              AppButton(
                'WhatsApp',
                variant: AppButtonVariant.action,
                onPressed: busy ? null : onWhatsApp,
              ),
              Semantics(
                label: 'Cetak struk',
                button: true,
                enabled: !busy,
                excludeSemantics: true,
                onTap: busy ? null : onPrint,
                child: Tooltip(
                  message: 'Cetak struk',
                  child: AppButton(
                    '',
                    variant: AppButtonVariant.actionOutline,
                    icon: AppIcons.printer,
                    onPressed: busy ? null : onPrint,
                  ),
                ),
              ),
              if (onRecord != null)
                AppButton(
                  'Catat pembayaran',
                  variant: AppButtonVariant.action,
                  onPressed: busy ? null : onRecord,
                ),
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
            ])
              SizedBox(width: width, height: height, child: action),
          ],
        );
      },
    );
  }
}
