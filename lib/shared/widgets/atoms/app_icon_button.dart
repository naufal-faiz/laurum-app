import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_control_tokens.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_avatar.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_svg.dart';

enum AppIconButtonVariant { plain, hero, compact, tilePrimary, tileSuccess, tileNeutral }

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.label,
    super.key,
    this.variant = AppIconButtonVariant.plain,
    this.icon,
    this.iconAsset,
    this.onPressed,
    this.color = AppColors.primary,
    this.initials,
  }) : assert(
         (icon == null) != (iconAsset == null),
         'Provide exactly one of icon or iconAsset.',
       );
  final AppIcons? icon;
  final String? iconAsset;
  final String label;
  final AppIconButtonVariant variant;
  final VoidCallback? onPressed;
  final Color color;
  final String? initials;
  @override
  Widget build(BuildContext context) {
    final hero = variant == AppIconButtonVariant.hero;
    final compact = variant == AppIconButtonVariant.compact;
    final tile = variant.index >= AppIconButtonVariant.tilePrimary.index;
    final success = variant == AppIconButtonVariant.tileSuccess;
    final tint = hero
        ? AppColors.onPrimary
        : onPressed == null
        ? AppControlTokens.disabledForeground
        : success
        ? AppColors.successInk
        : color;
    final glyphSize = tile
        ? AppDimensions.icon
        : hero
        ? AppDimensions.iconBack
        : AppDimensions.iconAction;
    final glyph = initials != null
        ? AppAvatar(initials: initials, semanticLabel: label)
        : iconAsset != null
        ? AppSvg(iconAsset!, size: glyphSize, color: tint)
        : AppIcon(icon!, size: glyphSize, color: tint);
    final heroStyle = IconButton.styleFrom(
      minimumSize: const Size.square(AppControlTokens.buttonMedium),
      maximumSize: const Size.square(AppControlTokens.buttonMedium),
      padding: EdgeInsets.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: const CircleBorder(),
    );
    final plainStyle = IconButton.styleFrom(
      minimumSize: Size.square(compact ? AppControlTokens.buttonSmall : AppSpacing.touchTarget),
      maximumSize: Size.square(compact ? AppControlTokens.buttonSmall : AppSpacing.touchTarget),
      padding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.action),
      backgroundColor: tile
          ? (success
                ? AppColors.successTint
                : variant == AppIconButtonVariant.tilePrimary
                ? AppColors.primaryTint
                : AppColors.surfaceLow)
          : null,
      disabledBackgroundColor: tile ? AppColors.chipIdle : null,
      tapTargetSize: compact ? MaterialTapTargetSize.shrinkWrap : null,
    );
    return IconButton(
      tooltip: label,
      onPressed: onPressed,
      style: hero ? heroStyle : plainStyle,
      icon: hero
          ? SizedBox.square(
              dimension: AppDimensions.backButton,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.illustration,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.backBorder),
                ),
                child: Center(child: glyph),
              ),
            )
          : glyph,
    );
  }
}
