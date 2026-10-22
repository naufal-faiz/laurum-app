import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  }) : assert(onAction == null || actionLabel != null);
  final String title;
  final String? subtitle, actionLabel;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(title, variant: AppTextVariant.section),
            if (subtitle != null)
              AppText(subtitle!, variant: AppTextVariant.caption, color: AppColors.ink3),
          ],
        ),
      ),
      if (actionLabel != null)
        TextButton(
          onPressed: onAction,
          child: AppText(actionLabel!, variant: AppTextVariant.label, color: AppColors.primary),
        ),
    ],
  );
}
