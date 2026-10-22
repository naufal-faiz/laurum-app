import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/core/theme/app_text_styles.dart';

abstract final class AppTheme {
  static final light = ThemeData(
    fontFamily: AppTextStyles.fontFamily,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryTint,
      onPrimaryContainer: AppColors.primary,
      secondary: AppColors.primary,
      onSecondary: AppColors.onPrimary,
      onSurface: AppColors.ink,
      error: AppColors.error,
      errorContainer: AppColors.errorTint,
      onErrorContainer: AppColors.errorInk,
      outline: AppColors.border,
      outlineVariant: AppColors.borderStrong,
      scrim: AppColors.scrim,
    ),
    textTheme: const TextTheme(
      headlineLarge: AppTextStyles.titleRoot,
      titleLarge: AppTextStyles.titleSub,
      titleMedium: AppTextStyles.section,
      bodyLarge: AppTextStyles.input,
      bodyMedium: AppTextStyles.body,
      bodySmall: AppTextStyles.caption,
      labelLarge: AppTextStyles.cta,
      labelMedium: AppTextStyles.label,
    ).apply(bodyColor: AppColors.ink, displayColor: AppColors.ink),
    dividerColor: AppColors.border,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.appBarBg,
      foregroundColor: AppColors.ink,
      toolbarHeight: AppSpacing.appBarHeight,
      titleTextStyle: AppTextStyles.titleSub,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
  );
}
