import 'package:flutter/material.dart';
import 'package:laurum/features/auth/widgets/sign_in_brand_section.dart';
import 'package:laurum/features/auth/widgets/sign_in_illustration_section.dart';
import 'package:laurum/shared/widgets/organisms/auth_hero.dart';

/// Gradient hero of frame `LAURUM · Masuk`: brand lockup + shirt illustration.
class SignInHeroSection extends StatelessWidget {
  const SignInHeroSection({super.key});

  @override
  Widget build(BuildContext context) => const AuthHero(
    height: 340,
    title: 'Masuk',
    subtitle: 'Kasir laundry untuk usaha rumahan',
    brand: SignInBrandSection(),
    illustration: SignInIllustrationSection(),
  );
}
