import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    required this.icon,
    super.key,
    this.description,
    this.actionLabel,
    this.onAction,
  }) : assert(onAction == null || actionLabel != null);
  final String title;
  final AppIcons icon;
  final String? description, actionLabel;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSpacing.cardPadding),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppMoleculeTokens.emptyCircle,
          height: AppMoleculeTokens.emptyCircle,
          decoration: const BoxDecoration(color: AppColors.primaryTint, shape: BoxShape.circle),
          child: AppIcon(icon, size: AppMoleculeTokens.emptyIcon, color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.cardGap),
        AppText(title, variant: AppTextVariant.section, textAlign: TextAlign.center),
        if (description != null) ...[
          const SizedBox(height: AppSpacing.cardGap),
          AppText(description!, color: AppColors.ink2, textAlign: TextAlign.center),
        ],
        if (actionLabel != null) ...[
          const SizedBox(height: AppSpacing.cardGap),
          AppButton(actionLabel!, variant: AppButtonVariant.action, onPressed: onAction),
        ],
      ],
    ),
  );
}
