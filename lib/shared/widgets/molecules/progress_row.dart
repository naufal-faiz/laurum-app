import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class ProgressRow extends StatelessWidget {
  const ProgressRow({required this.label, required this.progress, super.key, this.value})
    : assert(progress >= 0 && progress <= 1);
  final String label;
  final double progress;
  final String? value;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: AppMoleculeTokens.gap,
    children: [
      Row(
        children: [
          Expanded(child: AppText(label, variant: AppTextVariant.bodyStrong)),
          if (value != null) Flexible(child: AppText(value!, variant: AppTextVariant.label)),
        ],
      ),
      LinearProgressIndicator(
        value: progress,
        minHeight: AppMoleculeTokens.progressHeight,
        borderRadius: AppRadius.chip,
        backgroundColor: AppColors.chipIdle,
        color: AppColors.primary,
        semanticsLabel: label,
      ),
    ],
  );
}
