import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';

abstract final class AppChartStyles {
  static const peakLabel = BoxDecoration(color: AppColors.chipIdle, borderRadius: AppRadius.chip);
  static const revenueBar = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [AppColors.primaryTint, AppColors.primary],
    ),
    borderRadius: AppRadius.input,
  );
}
