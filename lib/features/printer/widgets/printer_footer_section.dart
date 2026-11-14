import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

class PrinterFooterSection extends StatelessWidget {
  const PrinterFooterSection({
    required this.busy,
    required this.onSave,
    required this.onTestPrint,
    super.key,
  });
  final bool busy;
  final VoidCallback onSave, onTestPrint;

  @override
  Widget build(BuildContext context) => Row(
    spacing: AppSpacing.cardGap,
    children: [
      Expanded(
        child: AppButton(
          'Cetak uji',
          variant: AppButtonVariant.secondary,
          onPressed: busy ? null : onTestPrint,
        ),
      ),
      Expanded(
        flex: 2,
        child: AppButton('Simpan pengaturan', onPressed: onSave),
      ),
    ],
  );
}
