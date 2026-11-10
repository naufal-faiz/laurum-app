import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_text_styles.dart';
import 'package:laurum/features/auth/widgets/sign_in_illustration_section.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';

/// Logo, brand name, tagline and shirt illustration of frame `LAURUM · Masuk`.
/// Title and subtitle live in the hero organism.
class SignInBrandSection extends StatelessWidget {
  const SignInBrandSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          left: 24,
          top: 58,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.logo,
            ),
            child: SizedBox(
              width: 38,
              height: 38,
              child: Center(
                child: AppIcon(AppIcons.droplet, size: 18, color: AppColors.primary),
              ),
            ),
          ),
        ),
        Positioned(
          left: 72,
          top: 60,
          child: Text(
            'LAURUM',
            style: AppTextStyles.brand.copyWith(color: AppColors.surface),
          ),
        ),
        Positioned(
          left: 72,
          top: 80,
          child: Text(
            'LAUNDRY MANAGEMENT',
            style: AppTextStyles.brandSub.copyWith(
              color: AppColors.heroTagline,
            ),
          ),
        ),
        const Positioned(
          right: 28,
          top: 150,
          child: SignInIllustrationSection(),
        ),
      ],
    );
  }
}
