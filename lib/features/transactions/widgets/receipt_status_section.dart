import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/state/receipt_print_controller.dart';
import 'package:laurum/features/transactions/state/receipt_view.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';

class ReceiptStatusSection extends StatelessWidget {
  const ReceiptStatusSection({
    required this.view,
    required this.printState,
    required this.printerStatus,
    required this.printerName,
    required this.onRetry,
    required this.onSettings,
    super.key,
  });
  final ReceiptView view;
  final ReceiptPrintState printState;
  final PrintStatus printerStatus;
  final String? printerName;
  final VoidCallback onRetry, onSettings;
  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.small,
      children: [
        Row(
          spacing: AppSpacing.small,
          children: [
            const AppIcon(AppIcons.printer),
            Expanded(
              child: AppText(
                printerStatus == PrintStatus.connected && printerName != null
                    ? 'Terhubung: $printerName'
                    : 'Printer belum terhubung',
                variant: AppTextVariant.label,
                color: printerStatus == PrintStatus.connected
                    ? AppColors.successInk
                    : AppColors.ink3,
              ),
            ),
            if (printState.error != null)
              AppIconButton(
                label: 'Coba lagi',
                icon: AppIcons.refresh,
                onPressed: printState.printing ? null : onRetry,
              ),
            AppIconButton(
              label: 'Pengaturan printer',
              icon: AppIcons.settings,
              onPressed: onSettings,
            ),
          ],
        ),
        if (printState.error != null)
          BannerMessage(message: printState.error!, variant: BannerMessageVariant.error),
        if (printState.notice != null) BannerMessage(message: printState.notice!),
      ],
    ),
  );
}
