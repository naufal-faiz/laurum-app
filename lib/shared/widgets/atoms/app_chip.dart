import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_control_tokens.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class AppChip extends StatelessWidget {
  const AppChip(this.label, {super.key, this.selected = false, this.onPressed});
  final String label;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: Semantics(
      selected: selected,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: selected ? AppColors.primary : AppColors.chipIdle,
          disabledBackgroundColor: AppColors.chipIdle,
          minimumSize: const Size(AppSpacing.touchTarget, AppSpacing.touchTarget),
          padding: AppControlTokens.horizontalPadding,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.chip),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: AppText(
          label,
          variant: AppTextVariant.label,
          color: onPressed == null
              ? AppControlTokens.disabledForeground
              : selected
              ? AppColors.onPrimary
              : AppColors.ink2,
        ),
      ),
    ),
  );
}
