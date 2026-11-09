import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_svgs.dart';
import 'package:laurum/core/theme/app_auth_text_styles.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
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
          colors: [AppColors.authHeroGradientStart, AppColors.authHeroGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.authHero,
      ),
      child: Stack(
        children: [
          const Positioned(
            right: -90,
            top: -90,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.authHeroBlob,
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
                color: AppColors.authHeroBlobSoft,
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
                  color: AppColors.authIllustration,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.authBackBorder),
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
              style: AppAuthTextStyles.heroTitle.copyWith(color: AppColors.surface),
            ),
          ),
          Positioned(
            left: 24,
            top: 148,
            child: Text(
              'Buat akun untuk mulai mengelola usaha',
              style: AppAuthTextStyles.heroSub.copyWith(color: AppColors.authHeroTagline),
            ),
          ),
        ],
      ),
    );
  }
}
