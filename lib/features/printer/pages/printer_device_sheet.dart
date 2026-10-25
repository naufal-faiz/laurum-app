import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/features/printer/state/printer_connection.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';

class PrinterDeviceSheet extends ConsumerWidget {
  const PrinterDeviceSheet({super.key});

  static Future<void> show(BuildContext context, WidgetRef ref) => AppBottomSheet.show<void>(
    context: context,
    title: 'Cari printer',
    subtitle: 'Pilih printer thermal yang terdeteksi',
    child: const PrinterDeviceSheet(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(printerConnectionProvider);
    final devices = state.devices;
    return SizedBox(
      height: 360,
      child: devices.isEmpty
          ? EmptyState(
              title: 'Printer tidak ditemukan',
              icon: AppIcons.printer,
              description: 'Pastikan printer menyala dan Bluetooth aktif.',
              actionLabel: 'Cari lagi',
              onAction: () => ref.read(printerConnectionProvider.notifier).discover(),
            )
          : ListView(
              children: [
                for (final device in devices)
                  MenuRow(
                    label: device.name,
                    subtitle: device.id,
                    icon: AppIcons.printer,
                    onTap: () async {
                      final ok = await ref.read(printerConnectionProvider.notifier).connect(device);
                      if (ok && context.mounted) Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
    );
  }
}
