import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/printer/state/printer_settings_edit.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_chip.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

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
    child: Column(
      spacing: AppSpacing.medium,
      children: [
        Row(
          children: [
            const Expanded(
              child: AppText(
                'Lebar kertas',
                variant: AppTextVariant.bodyStrong,
              ),
            ),
            Wrap(
              spacing: AppSpacing.small,
              children: [
                for (final paper in [58, 80])
                  AppChip(
                    '$paper mm',
                    selected: paperMm == paper,
                    onPressed: paper == 80
                        ? () => onNotice(
                            'Printer 80 mm masih coming soon. Untuk sekarang gunakan 58 mm.',
                          )
                        : () => onEdit(paperMm: paper),
                  ),
              ],
            ),
          ],
        ),
        const AppDivider(),
        Row(
          children: [
            const Expanded(
              child: AppText(
                'Ukuran huruf',
                variant: AppTextVariant.bodyStrong,
              ),
            ),
            Wrap(
              spacing: AppSpacing.small,
              children: [
                for (final size in [11, 13])
                  AppChip(
                    size == 11 ? 'Normal' : 'Besar',
                    selected: fontSize == size,
                    onPressed: () => onEdit(fontSize: size),
                  ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
