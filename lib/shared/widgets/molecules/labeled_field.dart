import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class LabeledField extends StatelessWidget {
  const LabeledField({
    required this.label,
    required this.child,
    super.key,
    this.helperText,
    this.errorText,
  });
  final String label;
  final Widget child;
  final String? helperText, errorText;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      AppText(label, variant: AppTextVariant.bodyStrong),
      const SizedBox(height: AppMoleculeTokens.labelGap),
      child,
      if (errorText != null || helperText != null) ...[
        const SizedBox(height: AppMoleculeTokens.labelGap),
        AppText(
          errorText ?? helperText!,
          variant: AppTextVariant.caption,
          color: errorText != null ? AppColors.errorInk : AppColors.ink3,
        ),
      ],
    ],
  );
}
