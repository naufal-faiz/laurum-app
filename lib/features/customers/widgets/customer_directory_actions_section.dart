import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

class CustomerDirectoryActionsSection extends StatelessWidget {
  const CustomerDirectoryActionsSection({
    required this.onImport,
    required this.onAdd,
    super.key,
  });
  final VoidCallback onImport;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final importButton = AppButton(
      'Impor kontak',
      variant: AppButtonVariant.actionOutline,
      onPressed: onImport,
    );
    final addButton = AppButton('Pelanggan baru', icon: AppIcons.add, onPressed: onAdd);
    final scaled = MediaQuery.textScalerOf(context).scale(1) >= 1.3;
    return LayoutBuilder(
      builder: (context, constraints) => scaled || constraints.maxWidth < 360
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.cardGap,
              children: [importButton, addButton],
            )
          : Row(
              children: [
                Expanded(child: importButton),
                const SizedBox(width: AppSpacing.cardGap),
                Expanded(child: addButton),
              ],
            ),
    );
  }
}
