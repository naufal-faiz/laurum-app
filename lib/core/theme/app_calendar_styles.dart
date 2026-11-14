import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';

abstract final class AppCalendarStyles {
  static ButtonStyle day({required bool selected, required bool inRange}) => TextButton.styleFrom(
    minimumSize: const Size.square(AppSpacing.minTouchTarget),
    padding: EdgeInsets.zero,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    backgroundColor: selected
        ? AppColors.primary
        : inRange
        ? AppColors.primaryTint
        : AppColors.surface,
    disabledBackgroundColor: AppColors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: selected || !inRange ? AppRadius.small : BorderRadius.zero,
    ),
  );
}
