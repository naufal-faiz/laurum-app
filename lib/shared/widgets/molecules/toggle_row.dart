import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_switch.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class ToggleRow extends StatelessWidget {
  const ToggleRow({
    required this.label,
    required this.value,
    super.key,
    this.description,
    this.icon,
    this.onChanged,
  });
  final String label;
  final bool value;
  final AppIcons? icon;
  final String? description;
  final ValueChanged<bool>? onChanged;
  @override
  Widget build(BuildContext context) => Padding(
    padding: AppMoleculeTokens.rowPadding,
    child: Row(
      children: [
        if (icon != null) ...[
          AppIcon(icon!, size: AppDimensions.iconSmall),
          const SizedBox(width: AppMoleculeTokens.gap),
        ],
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(label, variant: AppTextVariant.bodyStrong),
              if (description != null)
                AppText(description!, variant: AppTextVariant.caption, color: AppColors.ink3),
            ],
          ),
        ),
        const SizedBox(width: AppMoleculeTokens.gap),
        AppSwitch(value: value, label: label, onChanged: onChanged),
      ],
    ),
  );
}
