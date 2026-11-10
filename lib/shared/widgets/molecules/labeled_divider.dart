import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

/// Separator with a label in the middle: line, label, line. Example: "atau".
class LabeledDivider extends StatelessWidget {
  const LabeledDivider(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Expanded(child: AppDivider()),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.smallMedium),
        child: AppText(label, variant: AppTextVariant.caption, color: AppColors.ink3),
      ),
      const Expanded(child: AppDivider()),
    ],
  );
}
