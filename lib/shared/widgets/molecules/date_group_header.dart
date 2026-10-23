import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class DateGroupHeader extends StatelessWidget {
  const DateGroupHeader({
    required this.label,
    super.key,
    this.summary,
    this.summaryColor = AppColors.ink2,
  });
  final String label;
  final String? summary;
  final Color summaryColor;
  @override
  Widget build(BuildContext context) => Container(
    color: AppColors.chipIdle,
    padding: AppMoleculeTokens.datePadding,
    child: Row(
      children: [
        Container(
          width: AppMoleculeTokens.gap,
          height: AppMoleculeTokens.gap,
          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppMoleculeTokens.gap),
        Expanded(child: AppText(label, variant: AppTextVariant.bodyStrong)),
        if (summary != null)
          Expanded(
            child: AppText(
              summary!,
              variant: AppTextVariant.label,
              color: summaryColor,
              textAlign: TextAlign.end,
            ),
          ),
      ],
    ),
  );
}
