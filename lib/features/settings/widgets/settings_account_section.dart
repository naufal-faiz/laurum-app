import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/locked_row.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class SettingsAccountSection extends StatelessWidget {
  const SettingsAccountSection({required this.onLogout, super.key});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      const SectionHeader(title: 'AKUN'),
      const AppCard(
        child: LockedRow(
          label: 'Email Google & hapus akun',
          lockLabel: 'Segera',
          description: 'Dilengkapi bersama sinkronisasi.',
          icon: AppIcons.person,
        ),
      ),
      AppButton(
        'Keluar',
        variant: AppButtonVariant.destructiveOutline,
        icon: AppIcons.logout,
        onPressed: onLogout,
      ),
      const AppText(
        'Laurum v1.0.0',
        variant: AppTextVariant.caption,
        textAlign: TextAlign.center,
      ),
    ],
  );
}
