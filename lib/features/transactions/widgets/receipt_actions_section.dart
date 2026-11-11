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
  Widget build(BuildContext context) => Row(
    spacing: AppSpacing.small,
    children: [
      Expanded(
        child: AppButton('Selesai', icon: AppIcons.check, onPressed: busy ? null : onHome),
      ),
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
}
