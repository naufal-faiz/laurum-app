import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_control_tokens.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_shadows.dart';
import 'package:laurum/core/theme/app_spacing.dart';

enum AppButtonVariant {
  cta,
  secondary,
  action,
  actionOutline,
  neutralOutline,
  destructiveOutline,
  destructiveFilled,
}

/// Tinggi tombol: 50 / 44 / 40 (keputusan desain 4).
enum AppButtonSize { large, medium, small }

abstract final class AppButtonStyles {
  static bool filled(AppButtonVariant variant) =>
      variant == AppButtonVariant.cta ||
      variant == AppButtonVariant.action ||
      variant == AppButtonVariant.destructiveFilled;
  static Color accent(AppButtonVariant variant) => switch (variant) {
    AppButtonVariant.destructiveOutline || AppButtonVariant.destructiveFilled => AppColors.error,
    AppButtonVariant.neutralOutline => AppColors.borderStrong,
    _ => AppColors.primary,
  };
  static Color foreground(AppButtonVariant variant) => switch (variant) {
    AppButtonVariant.neutralOutline => AppColors.ink,
    _ => filled(variant) ? AppColors.onPrimary : accent(variant),
  };

  static AppButtonSize sizeFor(AppButtonVariant variant, AppButtonSize? size) =>
      size ?? (variant == AppButtonVariant.cta ? AppButtonSize.large : AppButtonSize.medium);

  static double heightOf(AppButtonSize size) => switch (size) {
    AppButtonSize.large => AppControlTokens.buttonLarge,
    AppButtonSize.medium => AppControlTokens.buttonMedium,
    AppButtonSize.small => AppControlTokens.buttonSmall,
  };

  static ButtonStyle of(AppButtonVariant variant, {AppButtonSize? size}) {
    final rounded =
        variant == AppButtonVariant.cta ||
        variant == AppButtonVariant.secondary ||
        variant == AppButtonVariant.neutralOutline;
    return TextButton.styleFrom(
      backgroundColor: filled(variant) ? accent(variant) : AppColors.surface,
      foregroundColor: foreground(variant),
      disabledBackgroundColor: AppColors.chipIdle,
      disabledForegroundColor: AppControlTokens.disabledForeground,
      minimumSize: Size(AppSpacing.touchTarget, heightOf(sizeFor(variant, size))),
      padding: AppControlTokens.horizontalPadding,
      shape: RoundedRectangleBorder(borderRadius: rounded ? AppRadius.cta : AppRadius.action),
      elevation: variant == AppButtonVariant.neutralOutline ? 3 : 0,
      shadowColor: AppShadows.raised.first.color,
      tapTargetSize: size == AppButtonSize.small
          ? MaterialTapTargetSize.padded
          : MaterialTapTargetSize.shrinkWrap,
    ).copyWith(
      side: WidgetStateProperty.resolveWith(
        (states) => BorderSide(
          color: states.contains(WidgetState.disabled) ? AppColors.border : accent(variant),
        ),
      ),
    );
  }
}
