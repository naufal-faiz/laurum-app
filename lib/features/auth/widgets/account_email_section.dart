import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

/// Baris email hanya-baca di kartu PROFIL, sejajar dengan baris MenuRow.
class AccountEmailSection extends StatelessWidget {
  const AccountEmailSection({required this.email, super.key});

  final String email;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.mediumLarge,
      vertical: AppSpacing.medium,
    ),
    child: Row(
      spacing: AppSpacing.cardGap,
      children: [
        const AppIcon(
          AppIcons.mail,
          size: AppDimensions.iconSmall,
          color: AppColors.primary,
          boxed: true,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xxsmall,
            children: [
              const AppText('Email', variant: AppTextVariant.label),
              AppText(email, variant: AppTextVariant.caption, color: AppColors.ink3),
              const AppText(
                'Ganti email belum tersedia',
                variant: AppTextVariant.caption,
                color: AppColors.ink3,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppDimensions.iconAction),
      ],
    ),
  );
}
