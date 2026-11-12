import 'package:flutter/material.dart';
import 'package:laurum/shared/widgets/molecules/brand_lockup.dart';

/// Logo, brand name and tagline of frame `LAURUM · Masuk`; the hero positions it.
class SignInBrandSection extends StatelessWidget {
  const SignInBrandSection({super.key});

  @override
  Widget build(BuildContext context) =>
      const BrandLockup(name: 'LAURUM', tagline: 'Laundry Management');
}
