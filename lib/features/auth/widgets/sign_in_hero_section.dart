import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_text_styles.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';

class SignInHeroSection extends StatelessWidget {
  const SignInHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.authHeroGradientStart,
            AppColors.authHeroGradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: 20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            left: -60,
            bottom: 40,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface.withValues(alpha: 0.05),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const AppIcon(
                            AppIcons.droplet,
                            color: AppColors.authHeroGradientEnd,
                            size: 22,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 2,
                          children: [
                            Text(
                              'LAURUM',
                              style: AppTextStyles.heroLogo.copyWith(color: AppColors.surface),
                            ),
                            Text(
                              'LAUNDRY MANAGEMENT',
                              style: AppTextStyles.heroLogoSub.copyWith(
                                color: AppColors.authHeroTagline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Masuk',
                      style: AppTextStyles.heroTitle.copyWith(color: AppColors.surface),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Kasir laundry untuk usaha rumahan',
                      style: AppTextStyles.heroTagline.copyWith(
                        color: AppColors.authHeroTagline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 24,
            bottom: 20,
            child: SizedBox(
              width: 118,
              height: 118,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 118,
                    height: 118,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.blue.withValues(alpha: 0.2),
                    ),
                  ),
                  AppIcon(
                    AppIcons.service,
                    size: 48,
                    color: AppColors.surface.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
