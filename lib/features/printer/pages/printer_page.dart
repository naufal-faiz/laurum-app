import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/printer/data/receipt_demo.dart';
import 'package:laurum/features/printer/pages/printer_device_sheet.dart';
import 'package:laurum/features/printer/state/printer_connection.dart';
import 'package:laurum/features/printer/state/printer_restore.dart';
import 'package:laurum/features/printer/state/printer_settings.dart';
import 'package:laurum/features/printer/widgets/printer_connection_section.dart';
import 'package:laurum/features/printer/widgets/printer_footer_section.dart';
import 'package:laurum/features/printer/widgets/printer_preview_section.dart';
import 'package:laurum/features/printer/widgets/printer_settings_section.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_sub.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

class PrinterPage extends ConsumerWidget {
  const PrinterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(printerSettingsProvider);
    final connection = ref.watch(printerConnectionProvider);
    final controller = ref.read(printerSettingsProvider.notifier);
    ref.watch(printerRestoreProvider);
    return FormScaffold(
      title: 'Printer dan struk',
      subtitle: 'Koneksi & format nota kasir',
      backLabel: 'Kembali',
      appBarVariant: AppBarSubVariant.detail,
      onBack: () => context.pop(),
      trailing: AppBadge(
        connection.status == PrintStatus.bluetoothOff
            ? 'Bluetooth mati'
            : connection.connected != null
            ? 'Terhubung'
            : 'BT aktif',
        variant: connection.status == PrintStatus.bluetoothOff
            ? AppBadgeVariant.dibatalkan
            : AppBadgeVariant.siap,
      ),
      footer: PrinterFooterSection(
        busy: connection.busy,
        onSave: controller.save,
        onTestPrint: () => _testPrint(ref),
      ),
      body: settings.when(
        skipLoadingOnReload: true,
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
        data: (printer) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.cardGap,
          children: [
            PrinterConnectionSection(
              printer: connection,
              onFind: () => PrinterDeviceSheet.show(context, ref),
            ),
            PrinterSettingsSection(
              printer: printer,
              onEdit: controller.edit,
              onNotice: controller.showNotice,
            ),
            const PrinterPreviewSection(),
          ],
        ),
      ),
    );
  }

  Future<void> _testPrint(WidgetRef ref) async {
    final printer = ref.read(printerSettingsProvider).value;
    if (printer == null) return;
    await ref
        .read(printerConnectionProvider.notifier)
        .testPrint(
          demoReceiptLines(
            business: printer.profile,
            settings: printer.settings,
          ),
          paperMm: printer.settings.paperMm,
          fontSize: printer.settings.fontSize,
        );
  }
}
