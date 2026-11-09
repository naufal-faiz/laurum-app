import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_svgs.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_text_styles.dart';
import 'package:laurum/shared/widgets/atoms/app_svg.dart';

/// Gradient hero of frame `LAURUM · Daftar`: 390x230, bottom corners 32,
/// back button (36 dp circle) + title + subtitle. Tidak ada logo/ilustrasi.
class SignUpHeroSection extends StatelessWidget {
  const SignUpHeroSection({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
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
          const Positioned(
            right: -90,
            top: -90,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.heroBlob,
              ),
              child: SizedBox(width: 210, height: 210),
            ),
          ),
          const Positioned(
            right: -20,
            top: 120,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.heroBlobSoft,
              ),
              child: SizedBox(width: 110, height: 110),
            ),
          ),
          Positioned(
            left: 24,
            top: 56,
            child: GestureDetector(
              onTap: onBack,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.illustration,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.backBorder),
                ),
                child: const Center(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(AppColors.surface, BlendMode.srcIn),
                    child: AppSvg(AppSvgs.cursorBack, size: 20),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            top: 110,
            child: Text(
              'Daftar',
              style: AppTextStyles.hero.copyWith(color: AppColors.surface),
            ),
          ),
          Positioned(
            left: 24,
            top: 148,
            child: Text(
              'Buat akun untuk mulai mengelola usaha',
              style: AppTextStyles.body.copyWith(color: AppColors.heroTagline),
            ),
          ),
        ],
      ),
    );
  }
}
