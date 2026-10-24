import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/printer/pages/printer_connection.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';

class BluetoothSheet extends ConsumerWidget {
  const BluetoothSheet({super.key});

  static Future<void> show(BuildContext context, WidgetRef ref) => AppBottomSheet.show<void>(
    context: context,
    title: 'Aktifkan Bluetooth',
    subtitle: 'Printer thermal terhubung lewat Bluetooth',
    child: const BluetoothSheet(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) => SizedBox(
    height: 240,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        const AppText(
          'Bluetooth sedang mati. Aktifkan Bluetooth pada perangkat, lalu cari printer kembali.',
        ),
        AppButton(
          'Aktifkan Bluetooth',
          onPressed: () async {
            await ref.read(printerConnectionProvider.notifier).enableBluetooth();
            if (context.mounted) Navigator.of(context).pop();
          },
        ),
        AppButton(
          'Tutup',
          variant: AppButtonVariant.actionOutline,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}
