import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/auth/state/account_view.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';

class AccountProfileSection extends StatelessWidget {
  const AccountProfileSection({
    required this.data,
    required this.busy,
    required this.onName,
    required this.onPhone,
    super.key,
  });
  final AccountView data;
  final bool busy;
  final VoidCallback onName, onPhone;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.small,
    children: [
      const AppText('PROFIL', variant: AppTextVariant.label, color: AppColors.ink3),
      AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MenuRow(
              label: 'Nama',
              subtitle: data.name.isEmpty ? 'Belum diisi' : data.name,
              icon: AppIcons.person,
              compact: true,
              onTap: busy ? null : onName,
            ),
            const AppDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.mediumLarge,
                vertical: AppSpacing.smallMedium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xxsmall,
                children: [
                  const AppText('Email', variant: AppTextVariant.caption, color: AppColors.ink3),
                  AppText(data.email, variant: AppTextVariant.label),
                  const AppText(
                    'Ganti email belum tersedia',
                    variant: AppTextVariant.caption,
                    color: AppColors.ink3,
                  ),
                ],
              ),
            ),
            const AppDivider(),
            MenuRow(
              label: 'No. telp',
              subtitle: data.phone.isEmpty ? 'Belum diisi' : Formatters.telepon(data.phone),
              icon: AppIcons.phone,
              compact: true,
              onTap: busy ? null : onPhone,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.mediumLarge),
              child: AppText(
                'Opsional, tanpa OTP',
                variant: AppTextVariant.caption,
                color: AppColors.ink3,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
