import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';

abstract final class AppSurfaceStyles {
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.heroGradientStart, AppColors.heroGradientEnd],
  );
}
