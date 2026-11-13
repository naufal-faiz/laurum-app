import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/printer/state/printer_state.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';

class PrinterConnectionSection extends StatelessWidget {
  const PrinterConnectionSection({required this.printer, required this.onFind, super.key});
  final PrinterConnectionState printer;
  final VoidCallback onFind;

  @override
  Widget build(BuildContext context) {
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
        if (printer.connected != null)
          AppCard(
            child: Row(
              children: [
                const AppIcon(AppIcons.printer, color: AppColors.primary),
                const SizedBox(width: AppSpacing.cardGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(printer.connected!.name, variant: AppTextVariant.bodyStrong),
                      AppText(
                        printer.busy
                            ? 'Memproses koneksi printer...'
                            : 'Terhubung dan siap mencetak',
                      ),
                    ],
                  ),
                ),
                AppButton(
                  'Ganti',
                  variant: AppButtonVariant.actionOutline,
                  busy: printer.busy,
                  onPressed: onFind,
                ),
              ],
            ),
          )
        else ...[
          const BannerMessage(
            message: 'Printer belum terhubung.',
            variant: BannerMessageVariant.warning,
          ),
          AppButton(
            'Cari printer',
            variant: AppButtonVariant.actionOutline,
            icon: AppIcons.search,
            busy: printer.busy,
            onPressed: onFind,
          ),
        ],
      ],
    );
  }
}
