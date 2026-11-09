import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/features/auth/widgets/sign_in_brand_section.dart';
import 'package:laurum/features/auth/widgets/sign_in_illustration_section.dart';

/// Gradient hero of frame `LAURUM · Masuk`: 390x340, bottom corners 32.
class SignInHeroSection extends StatelessWidget {
  const SignInHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.heroGradientStart, AppColors.heroGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.hero,
      ),
      child: const Stack(
        children: [
          Positioned(
            right: -80,
            top: -80,
            child: DecoratedBox(
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.heroBlob),
              child: SizedBox(width: 210, height: 210),
            ),
          ),
          Positioned(
            right: -30,
            top: 120,
            child: DecoratedBox(
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.heroBlobSoft),
              child: SizedBox(width: 120, height: 120),
            ),
          ),
          Positioned(
            right: 136,
            top: 96,
            child: DecoratedBox(
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.heroDot),
              child: SizedBox(width: 4, height: 4),
            ),
          ),
          Positioned(
            right: 120,
            top: 112,
            child: DecoratedBox(
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.heroDot),
              child: SizedBox(width: 4, height: 4),
            ),
          ),
          Positioned(
            right: 102,
            top: 130,
            child: DecoratedBox(
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.heroDot),
              child: SizedBox(width: 4, height: 4),
            ),
          ),
          Positioned.fill(child: SignInBrandSection()),
          Positioned(right: 28, top: 150, child: SignInIllustrationSection()),
        ],
      ),
    );
  }
}
