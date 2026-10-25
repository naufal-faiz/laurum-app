import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/printer/pages/bluetooth_sheet.dart';
import 'package:laurum/features/printer/pages/printer_device_sheet.dart';
import 'package:laurum/features/printer/state/printer_connection.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';

class PrinterConnectionSection extends ConsumerWidget {
  const PrinterConnectionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final printer = ref.watch(printerConnectionProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        if (printer.notice != null)
          BannerMessage(
            message: printer.notice!,
            variant: printer.noticeError ? BannerMessageVariant.error : BannerMessageVariant.info,
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
                      const AppText('Terhubung dan siap mencetak'),
                    ],
                  ),
                ),
                AppButton(
                  'Ganti',
                  variant: AppButtonVariant.actionOutline,
                  onPressed: () => findPrinter(context, ref),
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
            onPressed: () => findPrinter(context, ref),
          ),
        ],
      ],
    );
  }
}

Future<void> findPrinter(BuildContext context, WidgetRef ref) async {
  final status = await ref.read(printerConnectionProvider.notifier).discover();
  if (!context.mounted) return;
  if (status == PrintStatus.bluetoothOff) {
    await BluetoothSheet.show(context, ref);
  } else {
    await PrinterDeviceSheet.show(context, ref);
  }
}
