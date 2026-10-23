import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_styles.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class StepperField extends StatelessWidget {
  const StepperField({
    required this.value,
    required this.decreaseLabel,
    required this.increaseLabel,
    required this.editLabel,
    super.key,
    this.onDecrease,
    this.onIncrease,
    this.onEdit,
  });
  final String value, decreaseLabel, increaseLabel, editLabel;
  final VoidCallback? onDecrease, onIncrease, onEdit;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    spacing: AppMoleculeTokens.smallGap,
    children: [
      Semantics(
        label: decreaseLabel,
        child: TextButton(
          onPressed: onDecrease,
          style: AppMoleculeStyles.stepperButton,
          child: AppText(
            '−',
            variant: AppTextVariant.titleSub,
            color: onDecrease == null ? AppColors.ink3 : AppColors.primary,
          ),
        ),
      ),
      Flexible(
        child: Semantics(
          label: editLabel,
          child: TextButton(
            onPressed: onEdit,
            style: AppMoleculeStyles.stepperValue,
            child: AppText(value, variant: AppTextVariant.bodyStrong),
          ),
        ),
      ),
      Semantics(
        label: increaseLabel,
        child: TextButton(
          onPressed: onIncrease,
          style: AppMoleculeStyles.stepperButton,
          child: AppText(
            '+',
            variant: AppTextVariant.titleSub,
            color: onIncrease == null ? AppColors.ink3 : AppColors.primary,
          ),
        ),
      ),
    ],
  );
}
