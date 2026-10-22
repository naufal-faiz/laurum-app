import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_control_tokens.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';

class AppSwitch extends StatelessWidget {
  const AppSwitch({required this.value, required this.label, super.key, this.onChanged});
  final bool value;
  final String label;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    toggled: value,
    enabled: onChanged != null,
    onTap: onChanged == null ? null : () => onChanged!(!value),
    child: ExcludeSemantics(
      child: Opacity(
        opacity: onChanged == null ? AppControlTokens.disabledOpacity : 1,
        child: TextButton(
          onPressed: onChanged == null ? null : () => onChanged!(!value),
          style: TextButton.styleFrom(
            minimumSize: const Size.square(AppSpacing.touchTarget),
            maximumSize: const Size.square(AppSpacing.touchTarget),
            padding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.chip),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Container(
            width: AppSpacing.touchTarget,
            height: AppControlTokens.switchHeight,
            padding: AppControlTokens.switchPadding,
            decoration: BoxDecoration(
              color: value ? AppColors.primary : AppColors.borderStrong,
              borderRadius: AppRadius.chip,
            ),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: AppControlTokens.switchThumb,
              height: AppControlTokens.switchThumb,
              decoration: const BoxDecoration(color: AppColors.onPrimary, shape: BoxShape.circle),
            ),
          ),
        ),
      ),
    ),
  );
}
