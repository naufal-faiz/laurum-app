import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class MenuRow extends StatelessWidget {
  const MenuRow({required this.label, required this.icon, super.key, this.subtitle, this.onTap});
  final String label;
  final AppIcons icon;
  final String? subtitle;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onTap,
    style: TextButton.styleFrom(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      minimumSize: const Size(0, AppSpacing.touchTarget),
    ),
    child: Row(
      children: [
        AppIcon(icon, color: AppColors.primary),
        const SizedBox(width: AppSpacing.cardGap),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                label,
                variant: AppTextVariant.bodyStrong,
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
