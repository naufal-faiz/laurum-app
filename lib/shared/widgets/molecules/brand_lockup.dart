import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/core/theme/app_text_styles.dart';
import 'package:laurum/shared/widgets/molecules/icon_tile.dart';

/// Logo tile, brand name and tagline (the lockup inside the auth hero).
class BrandLockup extends StatelessWidget {
  const BrandLockup({required this.name, required this.tagline, super.key});

  final String name, tagline;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const IconTile.logo(),
      const SizedBox(width: AppSpacing.smallMedium),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: AppTextStyles.brand.copyWith(color: AppColors.surface)),
          Text(
            tagline,
            style: AppTextStyles.brandSub.copyWith(color: AppColors.heroTagline),
          ),
        ],
      ),
    ],
  );
}
