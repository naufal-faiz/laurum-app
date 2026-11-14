import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_selection_styles.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class SelectionTile extends StatelessWidget {
  const SelectionTile({
    required this.label,
    required this.selected,
    required this.onPressed,
    this.subtitle,
    this.icon,
    this.compact = false,
    super.key,
  });
  final String label;
  final String? subtitle;
  final AppIcons? icon;
  final bool selected;
  final bool compact;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: TextButton(
        onPressed: onPressed,
        style: AppSelectionStyles.tile(selected: selected, compact: compact),
        child: Row(
          spacing: AppSpacing.medium,
          children: [
            if (icon != null)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: compact
                      ? AppColors.surface
                      : selected
                      ? AppColors.primaryTint
                      : AppColors.surfaceLow,
                  borderRadius: AppRadius.action,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.small),
                  child: AppIcon(icon!, size: AppDimensions.iconSmall, color: AppColors.primary),
                ),
              ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xxsmall,
                children: [
                  AppText(
                    label,
                    variant: AppTextVariant.label,
                    color: compact && selected ? AppColors.primary : AppColors.ink,
                  ),
                  if (subtitle != null)
                    AppText(subtitle!, variant: AppTextVariant.caption, color: AppColors.ink3),
                ],
              ),
            ),
            if (!compact)
              AppIcon(
                selected ? AppIcons.radioSelected : AppIcons.radioUnselected,
                size: AppDimensions.iconAction,
                color: selected ? AppColors.primary : AppColors.ink3,
              ),
          ],
        ),
      ),
    ),
  );
}
