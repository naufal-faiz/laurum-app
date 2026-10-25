import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/locked_row.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class SettingsAccountPage extends StatelessWidget {
  const SettingsAccountPage({required this.onLogout, super.key});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      const SectionHeader(title: 'AKUN'),
      AppCard(
        child: Column(
          children: [
            const LockedRow(
              label: 'Email Google & hapus akun',
              lockLabel: 'Segera',
              description: 'Dilengkapi bersama sinkronisasi.',
              icon: AppIcons.person,
            ),
            const AppDivider(),
            MenuRow(label: 'Keluar', icon: AppIcons.back, onTap: onLogout),
          ],
        ),
      ),
      const AppText(
        'Laurum v1.0.0',
        variant: AppTextVariant.caption,
        textAlign: TextAlign.center,
      ),
    ],
  );
}
