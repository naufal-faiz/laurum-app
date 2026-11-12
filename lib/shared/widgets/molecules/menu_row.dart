import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class MenuRow extends StatelessWidget {
  const MenuRow({
    required this.label,
    required this.icon,
    super.key,
    this.subtitle,
    this.onTap,
    this.compact = false,
    this.iconAsset,
    this.iconTileColor,
  });
  final String label;
  final AppIcons icon;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool compact;
  final String? iconAsset;
  final Color? iconTileColor;
  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onTap,
    style: TextButton.styleFrom(
      padding: compact
          ? const EdgeInsets.symmetric(
              horizontal: AppSpacing.mediumLarge,
              vertical: AppSpacing.xsmall,
            )
          : const EdgeInsets.all(AppSpacing.cardPadding),
      minimumSize: Size(0, compact ? AppSpacing.minTouchTarget : AppSpacing.touchTarget),
    ),
    child: Row(
      children: [
        AppIcon(
          icon,
          color: AppColors.primary,
          boxed: compact,
          assetName: iconAsset,
          boxColor: iconTileColor,
          size: compact ? AppDimensions.iconSmall : AppDimensions.icon,
        ),
        const SizedBox(width: AppSpacing.cardGap),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                label,
                variant: compact ? AppTextVariant.label : AppTextVariant.bodyStrong,
                color: onTap == null ? AppColors.ink3 : AppColors.ink,
              ),
              if (subtitle != null)
                AppText(subtitle!, variant: AppTextVariant.caption, color: AppColors.ink3),
            ],
          ),
        ),
        const AppIcon(AppIcons.next, size: AppDimensions.iconAction),
      ],
    ),
  );
}
