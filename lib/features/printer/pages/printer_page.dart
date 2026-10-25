import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/printer/data/receipt_demo.dart';
import 'package:laurum/features/printer/pages/bluetooth_sheet.dart';
import 'package:laurum/features/printer/state/printer_connection.dart';
import 'package:laurum/features/printer/state/printer_settings.dart';
import 'package:laurum/features/printer/widgets/printer_connection_section.dart';
import 'package:laurum/features/printer/widgets/printer_preview_section.dart';
import 'package:laurum/features/printer/widgets/printer_settings_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

class PrinterPage extends ConsumerWidget {
  const PrinterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(printerSettingsProvider);
    return FormScaffold(
      title: 'Printer dan struk',
      backLabel: 'Kembali',
      onBack: () => context.pop(),
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.cardGap,
        children: [
          AppButton(
            'Simpan pengaturan',
            onPressed: () => ref.read(printerSettingsProvider.notifier).save(),
          ),
          AppButton(
            'Cetak uji',
            variant: AppButtonVariant.secondary,
            onPressed: () => _testPrint(context, ref),
          ),
        ],
      ),
      body: settings.when(
        loading: () => Column(
          spacing: AppSpacing.cardGap,
          children: [for (var i = 0; i < 4; i++) const AppSkeleton()],
        ),
        error: (_, _) => Center(
          child: EmptyState(
            title: 'Gagal memuat pengaturan',
            icon: AppIcons.alert,
            actionLabel: 'Coba lagi',
            onAction: () => ref.invalidate(printerSettingsProvider),
          ),
        ),
        data: (_) => const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.screenPadding,
          children: [
            PrinterConnectionSection(),
            PrinterSettingsSection(),
            PrinterPreviewSection(),
          ],
        ),
      ),
    );
  }

  Future<void> _testPrint(BuildContext context, WidgetRef ref) async {
    final printer = ref.read(printerSettingsProvider).value;
    if (printer == null) return;
    final status = await ref
        .read(printerConnectionProvider.notifier)
        .testPrint(
          demoReceiptLines(business: printer.profile, settings: printer.settings),
          paperMm: printer.settings.paperMm,
          fontSize: printer.settings.fontSize,
        );
    if (context.mounted && status == PrintStatus.bluetoothOff) {
      await BluetoothSheet.show(context, ref);
    }
  }
}
