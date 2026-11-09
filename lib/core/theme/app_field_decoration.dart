import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_input_styles.dart';
import 'package:laurum/core/theme/app_text_styles.dart';

/// Dekorasi dan gaya teks field global (dense = field form 48 dp).
abstract final class AppFieldDecoration {
  static InputDecoration of({
    required bool dense,
    String? hint,
    String? error,
    bool enabled = true,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) => dense
      ? AppInputStyles.field(
          hint: hint,
          error: error,
          enabled: enabled,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        )
      : AppInputStyles.decoration(
          hint: hint,
          error: error,
          enabled: enabled,
        ).copyWith(suffixIcon: suffixIcon);

  static TextStyle style({required bool dense, required bool enabled}) => dense
      ? AppInputStyles.fieldTextStyle(enabled: enabled)
      : AppTextStyles.input.copyWith(
          color: enabled ? AppColors.ink : AppColors.ink3,
        );
}
