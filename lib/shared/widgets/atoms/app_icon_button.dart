import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_control_tokens.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_svg.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.label,
    super.key,
    this.icon,
    this.iconAsset,
    this.onPressed,
    this.color = AppColors.primary,
  }) : assert(
         (icon == null) != (iconAsset == null),
         'Provide exactly one of icon or iconAsset.',
       );
  final AppIcons? icon;
  final String? iconAsset;
  final String label;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tint = onPressed == null ? AppControlTokens.disabledForeground : color;
    return IconButton(
      tooltip: label,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        minimumSize: const Size.square(AppSpacing.touchTarget),
        maximumSize: const Size.square(AppSpacing.touchTarget),
        padding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.action),
      ),
      icon: iconAsset != null
          ? AppSvg(iconAsset!, size: AppDimensions.iconAction, color: tint)
          : AppIcon(icon!, size: AppDimensions.iconAction, color: tint),
    );
  }
}
