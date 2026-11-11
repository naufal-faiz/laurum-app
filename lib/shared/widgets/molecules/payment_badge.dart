import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_control_tokens.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class PaymentBadge extends StatelessWidget {
  const PaymentBadge({required this.label, required this.status, super.key});
  final String label;
  final PayStatus status;
  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (status) {
      PayStatus.lunas => (AppColors.successTint, AppColors.successInk),
      PayStatus.dp => (AppColors.warningTint, AppColors.warningInk),
      PayStatus.belumBayar => (AppColors.errorTint, AppColors.errorInk),
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
