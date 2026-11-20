import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/printer/state/printer_state.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/icon_tile.dart';

class PrinterConnectionSection extends StatelessWidget {
  const PrinterConnectionSection({
    required this.printer,
    required this.onFind,
    super.key,
  });
  final PrinterConnectionState printer;
  final VoidCallback onFind;

  @override
  Widget build(BuildContext context) {
    final connected = printer.connected;
    final active = connected != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        if (printer.notice != null)
          BannerMessage(
            message: printer.notice!,
            variant: printer.status == PrintStatus.bluetoothOff
                ? BannerMessageVariant.warning
                : printer.noticeError
                ? BannerMessageVariant.error
                : BannerMessageVariant.success,
          ),
        AppCard(
          style: active ? AppCardStyle.success : AppCardStyle.muted,
          child: Row(
            children: [
              IconTile(
                icon: AppIcons.printer,
                size: AppDimensions.iconLarge,
                iconSize: AppDimensions.iconAction,
                background: active ? AppColors.successTint : AppColors.primaryTint,
                foreground: active ? AppColors.successInk : AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.cardGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xxsmall,
                  children: [
                    AppText(
                      connected?.name ?? 'Belum ada printer',
                      variant: AppTextVariant.bodyStrong,
                      color: active ? AppColors.successInk : AppColors.ink,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppText(
                      active
                          ? printer.busy
                                ? 'Memproses koneksi printer...'
                                : 'Terhubung dan siap mencetak'
                          : 'Belum terhubung',
                      variant: AppTextVariant.label,
                      color: active ? AppColors.successInk : AppColors.error,
                    ),
                    AppText(
                      active ? connected.id : 'Mendukung protokol ESC/POS 58/80 mm',
                      variant: AppTextVariant.caption,
                      color: AppColors.ink3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.small),
              AppButton(
                active ? 'Ganti' : 'Cari printer',
                variant: AppButtonVariant.actionOutline,
                size: AppButtonSize.small,
                busy: printer.busy,
                onPressed: onFind,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
