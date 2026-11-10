import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_svgs.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/core/theme/app_text_styles.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';

/// Gradient hero of the auth frames: ornaments, title and subtitle, plus either
/// a brand lockup with illustration (tall, `brand` non-null) or a back button.
class AuthHero extends StatelessWidget {
  const AuthHero({
    required this.height,
    required this.title,
    required this.subtitle,
    super.key,
    this.brand,
    this.onBack,
  });

  final double height;
  final String title, subtitle;
  final Widget? brand;
  final VoidCallback? onBack;
  static const _dots = [(136.0, 96.0), (120.0, 112.0), (102.0, 130.0)];

  @override
  Widget build(BuildContext context) {
    final tall = brand != null;
    final back = onBack;
    final titleStyle = AppTextStyles.hero.copyWith(color: AppColors.surface);
    final subStyle = AppTextStyles.body.copyWith(color: AppColors.heroTagline);
    return Container(
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.heroGradientStart, AppColors.heroGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.hero,
      ),
      child: Stack(
        children: [
          Positioned(
            right: tall ? -56 : -70,
            top: tall ? -80 : -90,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.heroBlob,
              ),
              child: SizedBox.square(dimension: 210),
            ),
          ),
          Positioned(
            right: tall ? -30 : -40,
            top: 120,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.heroBlobSoft,
              ),
              child: SizedBox.square(dimension: tall ? 120 : 110),
            ),
          ),
          if (tall)
            for (final dot in _dots)
              Positioned(
                right: dot.$1,
                top: dot.$2,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.heroDot,
                  ),
                  child: SizedBox.square(dimension: 4),
                ),
              ),
          if (brand != null) Positioned.fill(child: brand!),
          if (back != null)
            Positioned(
              left: AppSpacing.xlarge,
              top: 52,
              child: AppIconButton(
                variant: AppIconButtonVariant.hero,
                iconAsset: AppSvgs.cursorBack,
                label: 'Kembali',
                onPressed: back,
              ),
            ),
          Positioned(
            left: AppSpacing.xlarge,
            top: tall ? 140 : 110,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: titleStyle),
                Text(subtitle, style: subStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
