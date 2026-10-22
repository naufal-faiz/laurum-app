import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_control_tokens.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

enum AppBadgeVariant { diproses, siap, menungguJemput, selesai, dibatalkan }

class AppBadge extends StatelessWidget {
  const AppBadge(this.label, {required this.variant, super.key});
  final String label;
  final AppBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (variant) {
      AppBadgeVariant.diproses => (AppColors.blueTint, AppColors.blueInk),
      AppBadgeVariant.siap => (AppColors.primaryTint, AppColors.primary),
      AppBadgeVariant.menungguJemput ||
      AppBadgeVariant.selesai => (AppColors.slateTint, AppColors.slateInk),
      AppBadgeVariant.dibatalkan => (AppColors.errorTint, AppColors.errorInk),
    };
    return DecoratedBox(
      decoration: BoxDecoration(color: background, borderRadius: AppRadius.badge),
      child: Padding(
        padding: AppControlTokens.badgePadding,
        child: AppText(label, variant: AppTextVariant.label, color: foreground),
      ),
    );
  }
}
