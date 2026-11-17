import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_svgs.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_avatar.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_svg.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class AccountIdentitySection extends StatelessWidget {
  const AccountIdentitySection({
    required this.name,
    required this.email,
    required this.googleLinked,
    super.key,
  });

  final String name, email;
  final bool googleLinked;

  String get _initials => name
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .take(2)
      .map((word) => word.characters.first.toUpperCase())
      .join();

  @override
  Widget build(BuildContext context) => AppCard(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.cardGap,
      children: [
        AppAvatar(initials: _initials, semanticLabel: 'Foto profil'),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xxsmall,
            children: [
              AppText(
                name.trim().isEmpty ? 'Belum diisi' : name.trim(),
                variant: AppTextVariant.section,
              ),
              AppText(
                email.isEmpty ? 'Email belum diisi' : email,
                variant: AppTextVariant.caption,
                color: AppColors.ink3,
              ),
              if (googleLinked)
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: AppSpacing.xsmall,
                  children: [
                    AppSvg(
                      AppSvgs.google,
                      size: AppDimensions.iconSmall,
                      semanticLabel: 'Google',
                    ),
                    AppText(
                      'Tertaut dengan Google',
                      variant: AppTextVariant.caption,
                      color: AppColors.primaryInk,
                    ),
                  ],
                )
              else
                const AppText(
                  'Tidak tertaut dengan Google',
                  variant: AppTextVariant.caption,
                  color: AppColors.ink3,
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
