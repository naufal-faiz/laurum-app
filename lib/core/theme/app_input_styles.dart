import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/core/theme/app_text_styles.dart';

abstract final class AppInputStyles {
  static const padding = EdgeInsets.symmetric(horizontal: 12, vertical: 12);
  static const iconPadding = EdgeInsets.only(left: 12, right: 8);
  static const iconConstraints = BoxConstraints(minWidth: 40, minHeight: 48);
  static const skeletonHeight = 20.0;
  static const skeletonShort = 96.0;
  static const skeletonMedium = 192.0;
  static const numpadHeight = 56.0;
  static const border = OutlineInputBorder(
    borderRadius: AppRadius.input,
    borderSide: BorderSide(color: AppColors.borderStrong),
  );
  static const focusBorder = OutlineInputBorder(
    borderRadius: AppRadius.input,
    borderSide: BorderSide(color: AppColors.primary),
  );
  static const errorBorder = OutlineInputBorder(
    borderRadius: AppRadius.input,
    borderSide: BorderSide(color: AppColors.error),
  );

  static InputDecoration decoration({String? hint, String? error, bool enabled = true}) =>
      InputDecoration(
        hintText: hint,
        errorText: error,
        errorMaxLines: 3,
        hintStyle: AppTextStyles.input.copyWith(color: AppColors.placeholder),
        errorStyle: AppTextStyles.caption.copyWith(color: AppColors.errorInk),
        filled: true,
        fillColor: !enabled
            ? AppColors.chipIdle
            : error != null
            ? AppColors.errorTint
            : AppColors.surface,
        isDense: true,
        contentPadding: padding,
        constraints: const BoxConstraints(minHeight: AppSpacing.touchTarget),
        border: border,
        enabledBorder: border,
        disabledBorder: border,
        focusedBorder: focusBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
      );

  static final numpad = TextButton.styleFrom(
    backgroundColor: AppColors.surfaceLow,
    foregroundColor: AppColors.ink,
    disabledBackgroundColor: AppColors.chipIdle,
    disabledForegroundColor: AppColors.ink3,
    minimumSize: const Size(AppSpacing.touchTarget, numpadHeight),
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.numpad),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}
