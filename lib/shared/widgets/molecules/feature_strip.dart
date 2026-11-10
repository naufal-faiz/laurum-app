import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/core/theme/app_text_styles.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';

/// Static row of icon + label features (no actions, no state).
class FeatureStrip extends StatelessWidget {
  const FeatureStrip({required this.items, super.key});

  final List<({AppIcons icon, String label})> items;

  @override
  Widget build(BuildContext context) => Container(
    height: AppDimensions.barHeight,
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.mediumLarge),
    decoration: const BoxDecoration(
      color: AppColors.surfaceLow,
      borderRadius: AppRadius.bar,
    ),
    child: Row(
      children: [
        for (final item in items)
          Expanded(
            child: Row(
              children: [
                AppIcon(item.icon, size: 13, color: AppColors.primary),
                const SizedBox(width: AppSpacing.xsmall),
                Flexible(
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.ink),
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}
