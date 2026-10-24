import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class LockedRow extends StatelessWidget {
  const LockedRow({
    required this.label,
    required this.lockLabel,
    super.key,
    this.description,
    this.icon,
  });
  final AppIcons? icon;
  final String label, lockLabel;
  final String? description;
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
        const AppIcon(AppIcons.lock, size: AppDimensions.iconSmall, color: AppColors.ink3),
        const SizedBox(width: AppMoleculeTokens.smallGap),
        AppText(lockLabel, variant: AppTextVariant.label, color: AppColors.ink3),
      ],
    ),
  );
}
