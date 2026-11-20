import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/printer/state/printer_settings_edit.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/segmented_control.dart';

class PrinterFormatSection extends StatelessWidget {
  const PrinterFormatSection({
    required this.paperMm,
    required this.fontSize,
    required this.onEdit,
    required this.onNotice,
    super.key,
  });
  final int paperMm, fontSize;
  final PrinterSettingsEdit onEdit;
  final ValueChanged<String> onNotice;

  @override
  Widget build(BuildContext context) => AppCard(
    child: LayoutBuilder(
      builder: (context, constraints) {
        final stacked =
            constraints.maxWidth < AppSpacing.touchTarget * 6 ||
            MediaQuery.textScalerOf(context).scale(1) > 1.2;
        final controls = [
          SegmentedControl(
            labels: const ['58 mm', '80 mm'],
            selectedIndex: paperMm == 80 ? 1 : 0,
            onSelected: (index) => index == 0
                ? onEdit(paperMm: 58)
                : onNotice('Printer 80 mm masih coming soon. Untuk sekarang gunakan 58 mm.'),
          ),
          SegmentedControl(
            labels: const ['Normal', 'Besar'],
            selectedIndex: fontSize == 13 ? 1 : 0,
            onSelected: (index) => onEdit(fontSize: index == 0 ? 11 : 13),
          ),
        ];
        const labels = ['Lebar kertas', 'Ukuran huruf'];
        return Column(
          spacing: AppSpacing.medium,
          children: [
            for (var i = 0; i < labels.length; i++)
              if (stacked)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSpacing.small,
                  children: [
                    AppText(labels[i], variant: AppTextVariant.bodyStrong),
                    controls[i],
                  ],
                )
              else
                Row(
                  spacing: AppSpacing.medium,
                  children: [
                    AppText(labels[i], variant: AppTextVariant.bodyStrong),
                    Expanded(child: controls[i]),
                  ],
                ),
          ],
        );
      },
    ),
  );
}
