import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';

class SettingsAccountSection extends StatelessWidget {
  const SettingsAccountSection({
    required this.onLogout,
    required this.onManage,
    this.email = '',
    this.busy = false,
    super.key,
  });

  final VoidCallback onLogout, onManage;
  final String email;
  final bool busy;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.small,
    children: [
      const AppText('AKUN', variant: AppTextVariant.label, color: AppColors.ink3),
      AppCard(
        padding: const EdgeInsets.all(AppSpacing.xxsmall / 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.mediumLarge,
                vertical: AppSpacing.smallMedium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText('Email', variant: AppTextVariant.caption, color: AppColors.ink3),
                  AppText(email.isEmpty ? 'Belum masuk' : email, variant: AppTextVariant.label),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.mediumLarge),
              child: AppDivider(),
            ),
            MenuRow(
              compact: true,
              label: 'Kelola akun',
              subtitle: 'Nama, nomor HP, kata sandi',
              icon: AppIcons.person,
              onTap: busy ? null : onManage,
            ),
          ],
        ),
      ),
      AppButton(
        'Keluar',
        variant: AppButtonVariant.destructiveOutline,
        size: AppButtonSize.small,
        icon: AppIcons.logout,
        onPressed: busy ? null : onLogout,
      ),
    ],
  );
}
