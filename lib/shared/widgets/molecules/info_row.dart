import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({required this.label, required this.value, super.key, this.icon});
  final String label, value;
  final AppIcons? icon;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (icon != null) ...[
        AppIcon(icon!, size: AppDimensions.iconSmall),
        const SizedBox(width: AppMoleculeTokens.gap),
      ],
      Expanded(child: AppText(label, color: AppColors.ink2)),
      const SizedBox(width: AppMoleculeTokens.gap),
      Flexible(
        child: AppText(value, variant: AppTextVariant.bodyStrong, textAlign: TextAlign.end),
      ),
    ],
  );
}
