import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/icon_tile.dart';

/// Brand header of frame `LAURUM · Beranda`: logo, name, tagline, bell.
class BerandaHeaderSection extends StatelessWidget {
  const BerandaHeaderSection({super.key});

  @override
  Widget build(BuildContext context) => const Row(
    spacing: AppSpacing.smallMedium,
    children: [
      IconTile(
        icon: AppIcons.droplet,
        size: 42,
        iconSize: 20,
        background: AppColors.primary,
        foreground: AppColors.surface,
        radius: AppRadius.logo,
      ),
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'LAURUM',
              variant: AppTextVariant.section,
              color: AppColors.primaryInk,
            ),
            AppText(
              'Laundry Management',
              variant: AppTextVariant.caption,
              color: AppColors.ink3,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      IconTile(
        icon: AppIcons.bell,
        size: 38,
        iconSize: 18,
        background: AppColors.surfaceLow,
        foreground: AppColors.primaryInk,
        dot: true,
      ),
    ],
  );
}
