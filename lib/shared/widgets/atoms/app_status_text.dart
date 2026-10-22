import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

enum AppStatusTextVariant { lunas, belumBayar, dp }

class AppStatusText extends StatelessWidget {
  const AppStatusText(this.label, {required this.variant, super.key});
  final String label;
  final AppStatusTextVariant variant;

  @override
  Widget build(BuildContext context) => AppText(
    label,
    variant: AppTextVariant.label,
    color: switch (variant) {
      AppStatusTextVariant.lunas => AppColors.primary,
      AppStatusTextVariant.belumBayar => AppColors.error,
      AppStatusTextVariant.dp => AppColors.warningInk,
    },
  );
}
