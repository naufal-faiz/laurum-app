import 'package:flutter/material.dart';
import 'package:laurum/shared/widgets/organisms/auth_hero.dart';

/// Gradient hero of frame `LAURUM · Daftar`: back button + title + subtitle.
class SignUpHeroSection extends StatelessWidget {
  const SignUpHeroSection({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => AuthHero(
    height: 230,
    title: 'Daftar',
    subtitle: 'Buat akun untuk mulai mengelola usaha',
    onBack: onBack,
  );
}
