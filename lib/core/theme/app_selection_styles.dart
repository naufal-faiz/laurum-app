import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';

abstract final class AppSelectionStyles {
  static ButtonStyle tile({required bool selected, required bool compact}) => TextButton.styleFrom(
    backgroundColor: compact
        ? selected
              ? AppColors.primaryTint
              : AppColors.surfaceLow
        : AppColors.surface,
    minimumSize: const Size(0, AppSpacing.touchTarget),
    padding: const EdgeInsets.all(AppSpacing.medium),
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.card,
      side: compact
          ? BorderSide.none
          : BorderSide(color: selected ? AppColors.primary : AppColors.border),
    ),
  );
}
