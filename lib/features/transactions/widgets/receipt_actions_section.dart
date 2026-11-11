import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/icons/app_svgs.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';

class ReceiptActionsSection extends StatelessWidget {
  const ReceiptActionsSection({
    required this.busy,
    required this.onPrint,
    required this.onWhatsApp,
    required this.onHome,
    required this.onDownload,
    super.key,
  });
  final bool busy;
  final VoidCallback onPrint, onWhatsApp, onHome, onDownload;
  @override
  Widget build(BuildContext context) {
    final largeText = MediaQuery.textScalerOf(context).scale(1) > 1.3;
    final finish = AppButton(
      'Selesai',
      icon: largeText ? null : AppIcons.check,
      onPressed: busy ? null : onHome,
    );
    final quick = Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.small,
      children: [
        for (final (label, icon, asset, variant, action) in [
          ('WhatsApp', null, AppSvgs.whatsapp, AppIconButtonVariant.tileSuccess, onWhatsApp),
          ('Unduh', AppIcons.download, null, AppIconButtonVariant.tileNeutral, onDownload),
          ('Cetak struk', AppIcons.printer, null, AppIconButtonVariant.tilePrimary, onPrint),
        ])
          Semantics(
            label: label,
            button: true,
            enabled: !busy,
            excludeSemantics: true,
            onTap: busy ? null : action,
            child: AppIconButton(
              label: label,
              icon: icon,
              iconAsset: asset,
              variant: variant,
              onPressed: busy ? null : action,
            ),
          ),
      ],
    );
    return largeText
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.small,
            children: [
              finish,
              Align(alignment: Alignment.centerRight, child: quick),
            ],
          )
        : Row(
            spacing: AppSpacing.small,
            children: [
              Expanded(child: finish),
              quick,
            ],
          );
  }
}
