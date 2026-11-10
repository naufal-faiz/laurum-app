import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

/// Frequent-customer row: initials, name, detail and a frequency figure.
class RankRow extends StatelessWidget {
  const RankRow({
    required this.initials,
    required this.name,
    required this.detail,
    required this.trailing,
    super.key,
    this.onTap,
  });

  final String initials, name, detail, trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: AppRadius.action,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
      child: Row(
        spacing: AppSpacing.smallMedium,
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.primaryTint,
              shape: BoxShape.circle,
            ),
            child: SizedBox.square(
              dimension: 34,
              child: Center(
                child: AppText(
                  initials,
                  variant: AppTextVariant.label,
                  color: AppColors.primaryInk,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  name,
                  variant: AppTextVariant.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppText(
                  detail,
                  variant: AppTextVariant.caption,
                  color: AppColors.ink3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          AppText(trailing, variant: AppTextVariant.label, color: AppColors.primary),
        ],
      ),
    ),
  );
}
