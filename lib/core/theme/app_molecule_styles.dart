import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_shadows.dart';
import 'package:laurum/core/theme/app_spacing.dart';

abstract final class AppMoleculeStyles {
  static const appBar = BoxDecoration(
    color: AppColors.appBarBg,
    boxShadow: AppShadows.appBar,
    border: Border(
      bottom: BorderSide(color: AppColors.border),
    ),
  );
  static final stepperButton = TextButton.styleFrom(
    backgroundColor: AppColors.surface,
    minimumSize: const Size(AppSpacing.touchTarget, AppSpacing.touchTarget),
    padding: EdgeInsets.zero,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.action),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
  static final stepperValue = TextButton.styleFrom(
    backgroundColor: AppColors.bg,
    minimumSize: const Size(AppSpacing.touchTarget, AppSpacing.touchTarget),
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.cardPadding),
    shape: const RoundedRectangleBorder(
      borderRadius: AppRadius.action,
      side: BorderSide(color: AppColors.borderStrong),
    ),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}
