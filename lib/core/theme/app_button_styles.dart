import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_control_tokens.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';

enum AppButtonVariant {
  cta,
  secondary,
  action,
  actionOutline,
  destructiveOutline,
  destructiveFilled,
}

abstract final class AppButtonStyles {
  static bool filled(AppButtonVariant variant) =>
      variant == AppButtonVariant.cta ||
      variant == AppButtonVariant.action ||
      variant == AppButtonVariant.destructiveFilled;
  static Color accent(AppButtonVariant variant) =>
      variant == AppButtonVariant.destructiveOutline ||
          variant == AppButtonVariant.destructiveFilled
      ? AppColors.error
      : AppColors.primary;
  static Color foreground(AppButtonVariant variant) =>
      filled(variant) ? AppColors.onPrimary : accent(variant);
  static ButtonStyle of(AppButtonVariant variant) =>
      TextButton.styleFrom(
        backgroundColor: filled(variant) ? accent(variant) : AppColors.surface,
        foregroundColor: foreground(variant),
        disabledBackgroundColor: AppColors.chipIdle,
        disabledForegroundColor: AppControlTokens.disabledForeground,
        minimumSize: Size(
          AppSpacing.touchTarget,
          variant == AppButtonVariant.cta ? AppControlTokens.ctaHeight : AppSpacing.touchTarget,
        ),
        padding: AppControlTokens.horizontalPadding,
        shape: RoundedRectangleBorder(
          borderRadius: variant == AppButtonVariant.cta || variant == AppButtonVariant.secondary
              ? AppRadius.cta
              : AppRadius.action,
        ),

        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ).copyWith(
        side: WidgetStateProperty.resolveWith(
          (states) => BorderSide(
            color: states.contains(WidgetState.disabled) ? AppColors.border : accent(variant),
          ),
        ),
      );
}
