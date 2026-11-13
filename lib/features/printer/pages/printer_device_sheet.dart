import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/printer/state/printer_connection.dart';
import 'package:laurum/features/printer/state/saved_printer.dart';
import 'package:laurum/features/printer/widgets/printer_device_list_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_loader.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';

class PrinterDeviceSheet extends ConsumerWidget {
  const PrinterDeviceSheet({super.key});
  static Future<void> show(BuildContext context, WidgetRef ref) async {
    if (ref.read(printerConnectionProvider).busy) return;
    unawaited(ref.read(printerConnectionProvider.notifier).discover());
    await AppBottomSheet.show<void>(
      context: context,
      title: 'Cari printer',
      subtitle: 'Pilih printer thermal yang terdeteksi atau tersimpan',
      child: const PrinterDeviceSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(printerConnectionProvider);
    final saved = ref.watch(savedPrinterProvider).value;
    final controller = ref.read(printerConnectionProvider.notifier);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.cardGap,
        children: [
          if (state.busy) ...[
            const Center(child: AppLoader(size: AppDimensions.iconLarge)),
            AppText(
              state.status == PrintStatus.connecting
                  ? 'Menghubungkan printer...'
                  : 'Mencari printer...',
            ),
          ],
          if (state.notice != null)
            BannerMessage(
              message: state.notice!,
              variant: state.status == PrintStatus.bluetoothOff
                  ? BannerMessageVariant.warning
                  : state.noticeError
                  ? BannerMessageVariant.error
                  : BannerMessageVariant.success,
            ),
          if (!state.busy && state.devices.isEmpty && state.notice == null)
            const BannerMessage(
              message: 'Printer tidak ditemukan. Pastikan printer menyala dan dekat.',
            ),
          PrinterDeviceListSection(
            devices: state.devices,
            saved: saved,
            busy: state.busy,
            onSelect: (device) async {
              final ok = await controller.connect(device);
              if (ok && context.mounted) Navigator.of(context).pop();
            },
          ),
          AppButton(
            'Cari lagi',
            variant: AppButtonVariant.actionOutline,
            busy: state.busy,
            onPressed: controller.discover,
          ),
        ],
      ),
    );
  }
}
