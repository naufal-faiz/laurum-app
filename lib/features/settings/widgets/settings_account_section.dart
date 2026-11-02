import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

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
    spacing: AppSpacing.cardGap,
    children: [
      const SectionHeader(title: 'AKUN'),
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.cardGap,
          children: [
            const AppText('Email', variant: AppTextVariant.label),
            AppText(email.isEmpty ? 'Belum masuk' : email),
            MenuRow(label: 'Kelola akun', icon: AppIcons.person, onTap: busy ? null : onManage),
          ],
        ),
      ),
      AppButton(
        'Keluar',
        variant: AppButtonVariant.destructiveOutline,
        icon: AppIcons.logout,
        onPressed: busy ? null : onLogout,
      ),
      const AppText(
        'Laurum v1.0.0',
        variant: AppTextVariant.caption,
        textAlign: TextAlign.center,
      ),
    ],
  );
}
