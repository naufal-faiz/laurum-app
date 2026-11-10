import 'package:flutter/material.dart';
import 'package:laurum/features/auth/widgets/sign_in_brand_section.dart';
import 'package:laurum/shared/widgets/organisms/auth_hero.dart';
import 'package:widgetbook/widgetbook.dart';

final authHeroUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const AuthHero(
        height: 340,
        title: 'Masuk',
        subtitle: 'Kasir laundry untuk usaha rumahan',
        brand: SignInBrandSection(),
      ),
      AuthHero(
        height: 230,
        title: 'Daftar',
        subtitle: 'Buat akun untuk mulai mengelola usaha',
        onBack: () {},
      ),
    ],
  ),
);
