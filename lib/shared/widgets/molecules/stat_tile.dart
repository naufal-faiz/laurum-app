import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/core/theme/app_spacing.dart';
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
    this.compact = false,
    this.valueColor,
  });
  final String label, value;
  final String? description;
  final AppIcons? icon;
  final bool compact;
  final Color? valueColor;
  @override
  Widget build(BuildContext context) => AppCard(
    padding: compact
        ? AppMoleculeTokens.noticePadding
        : const EdgeInsets.all(AppSpacing.cardPadding),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: compact ? AppMoleculeTokens.smallGap : AppMoleculeTokens.gap,
      children: [
        if (icon != null) AppIcon(icon!, color: AppColors.primary),
        AppText(label, variant: AppTextVariant.label, color: AppColors.ink2),
        AppText(
          value,
          variant: compact ? AppTextVariant.section : AppTextVariant.figure,
          color: valueColor ?? AppColors.ink,
        ),
        if (description != null)
          AppText(description!, variant: AppTextVariant.caption, color: AppColors.ink3),
      ],
    ),
  );
}
