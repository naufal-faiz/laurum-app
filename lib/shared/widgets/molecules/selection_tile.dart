import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_radius.dart';
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
    super.key,
  });
  final String label;
  final String? subtitle;
  final AppIcons? icon;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: AppColors.surface,
          minimumSize: const Size(0, AppSpacing.touchTarget),
          padding: const EdgeInsets.all(AppSpacing.medium),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.card,
            side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
          ),
        ),
        child: Row(
          spacing: AppSpacing.medium,
          children: [
            if (icon != null)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: selected ? AppColors.primaryTint : AppColors.surfaceLow,
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
                  AppText(label, variant: AppTextVariant.bodyStrong),
                  if (subtitle != null)
                    AppText(subtitle!, variant: AppTextVariant.caption, color: AppColors.ink3),
                ],
              ),
            ),
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
