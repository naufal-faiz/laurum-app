import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_auth_text_styles.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_input_styles.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_text_styles.dart';

/// Field metrics for the auth redesign (frame LAURUM · Masuk): 48 dp, radius 12.
abstract final class AppFieldStyles {
  static const padding = EdgeInsets.only(right: 10, top: 13, bottom: 13);
  static const border = OutlineInputBorder(
    borderRadius: AppRadius.authField,
    borderSide: BorderSide(color: AppColors.authFieldBorder),
  );
  static const focusBorder = OutlineInputBorder(
    borderRadius: AppRadius.authField,
    borderSide: BorderSide(color: AppColors.authPrimary),
  );
  static const errorBorder = OutlineInputBorder(
    borderRadius: AppRadius.authField,
    borderSide: BorderSide(color: AppColors.error),
  );
  static const prefixConstraints = BoxConstraints(minWidth: 41, minHeight: 48);
  static const suffixConstraints = BoxConstraints(minWidth: 38, minHeight: 48);

  static TextStyle textStyle({required bool dense, required bool enabled}) => dense
      ? AppAuthTextStyles.input.copyWith(
          color: enabled ? AppColors.authInk : AppColors.authLabel,
        )
      : AppTextStyles.input.copyWith(color: enabled ? AppColors.ink : AppColors.ink3);

  static InputDecoration of({
    required bool dense,
    String? hint,
    String? error,
    bool enabled = true,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) => dense
      ? InputDecoration(
          hintText: hint,
          errorText: error,
          errorMaxLines: 2,
          hintStyle: AppAuthTextStyles.input.copyWith(color: AppColors.authPlaceholder),
          errorStyle: AppAuthTextStyles.meta.copyWith(color: AppColors.errorInk),
          filled: true,
          fillColor: !enabled
              ? AppColors.chipIdle
              : error != null
              ? AppColors.errorTint
              : AppColors.surface,
          isDense: true,
          contentPadding: padding,
          constraints: const BoxConstraints(minHeight: 48),
          prefixIcon: prefixIcon,
          prefixIconConstraints: prefixConstraints,
          suffixIcon: suffixIcon,
          suffixIconConstraints: suffixConstraints,
          border: border,
          enabledBorder: border,
          disabledBorder: border,
          focusedBorder: focusBorder,
          errorBorder: errorBorder,
          focusedErrorBorder: errorBorder,
        )
      : AppInputStyles.decoration(
          hint: hint,
          error: error,
          enabled: enabled,
        ).copyWith(suffixIcon: suffixIcon);
}
