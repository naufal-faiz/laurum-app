import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_auth_text_styles.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';

/// Logo, brand, title and subtitle of frame `LAURUM · Masuk`.
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
              borderRadius: AppRadius.authLogo,
            ),
            child: SizedBox(
              width: 38,
              height: 38,
              child: Center(
                child: AppIcon(AppIcons.droplet, size: 18, color: AppColors.authPrimary),
              ),
            ),
          ),
        ),
        Positioned(
          left: 72,
          top: 60,
          child: Text(
            'LAURUM',
            style: AppAuthTextStyles.heroBrand.copyWith(color: AppColors.surface),
          ),
        ),
        Positioned(
          left: 72,
          top: 80,
          child: Text(
            'LAUNDRY MANAGEMENT',
            style: AppAuthTextStyles.heroBrandSub.copyWith(
              color: AppColors.authHeroTagline,
            ),
          ),
        ),
        Positioned(
          left: 24,
          top: 140,
          child: Text(
            'Masuk',
            style: AppAuthTextStyles.heroTitle.copyWith(color: AppColors.surface),
          ),
        ),
        Positioned(
          left: 24,
          top: 174,
          child: Text(
            'Kasir laundry untuk usaha rumahan',
            style: AppAuthTextStyles.heroSub.copyWith(color: AppColors.authHeroTagline),
          ),
        ),
      ],
    );
  }
}
