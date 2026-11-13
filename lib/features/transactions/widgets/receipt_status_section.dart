import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/printer/state/printer_reconnect.dart';
import 'package:laurum/features/transactions/state/receipt_print_controller.dart';
import 'package:laurum/features/transactions/state/receipt_view.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/atoms/app_loader.dart';
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
    this.reconnect = (busy: false, result: null),
    super.key,
  });
  final ReceiptView view;
  final ReceiptPrintState printState;
  final PrinterReconnectState reconnect;
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
            if (reconnect.busy)
              const SizedBox.square(
                dimension: AppSpacing.touchTarget,
                child: Center(
                  child: AppLoader(
                    size: AppDimensions.iconAction,
                    label: 'Menghubungkan ulang printer',
                  ),
                ),
              )
            else
              AppIconButton(
                label: 'Refresh printer',
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
        if (printState.notice != null)
          BannerMessage(message: printState.notice!, variant: BannerMessageVariant.success),
        if (reconnect.result != null)
          BannerMessage(
            message: switch (reconnect.result!) {
              PrinterReconnectResult.success => 'Printer berhasil terhubung kembali.',
              PrinterReconnectResult.bluetoothOff =>
                'Aktifkan Bluetooth terlebih dahulu, lalu coba lagi.',
              PrinterReconnectResult.missing =>
                'Belum ada printer tersimpan. Pilih printer terlebih dahulu.',
              PrinterReconnectResult.failed =>
                'Gagal menghubungkan printer. Pastikan printer menyala dan dekat.',
            },
            variant: switch (reconnect.result!) {
              PrinterReconnectResult.success => BannerMessageVariant.success,
              PrinterReconnectResult.failed => BannerMessageVariant.error,
              _ => BannerMessageVariant.warning,
            },
          ),
      ],
    ),
  );
}
