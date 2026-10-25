import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/printer/data/receipt_demo.dart';
import 'package:laurum/features/printer/state/printer_settings.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/organisms/receipt_preview.dart';

class PrinterPreviewSection extends ConsumerWidget {
  const PrinterPreviewSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final printer = ref.watch(printerSettingsProvider).value;
    if (printer == null) return const SizedBox.shrink();
    final lines = demoReceiptLines(
      business: printer.profile,
      settings: printer.settings,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        SectionHeader(
          title: 'Pratinjau struk',
          subtitle: 'Thermal ${printer.settings.paperMm} mm',
        ),
        ReceiptPreview(
          lines: lines,
          width: printer.settings.paperMm == 80 ? 384 : 320,
        ),
        const AppText(
          'Pratinjau mengikuti pengaturan. Cetak ke printer asli belum diuji.',
          variant: AppTextVariant.caption,
          color: AppColors.ink3,
        ),
      ],
    );
  }
}
