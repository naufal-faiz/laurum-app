import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class StatTile extends StatelessWidget {
  const StatTile({
    required this.label,
    required this.value,
    super.key,
    this.description,
    this.icon,
  });
  final String label, value;
  final String? description;
  final AppIcons? icon;
  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppMoleculeTokens.gap,
      children: [
        if (icon != null) AppIcon(icon!, color: AppColors.primary),
        AppText(label, variant: AppTextVariant.label, color: AppColors.ink2),
        AppText(value, variant: AppTextVariant.figure),
        if (description != null)
          AppText(description!, variant: AppTextVariant.caption, color: AppColors.ink3),
      ],
    ),
  );
}
