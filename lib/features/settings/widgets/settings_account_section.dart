import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class SettingsAccountSection extends StatelessWidget {
  const SettingsAccountSection({
    required this.onLogout,
    this.email = '',
    this.onDelete,
    this.busy = false,
    this.deleteHint,
    super.key,
  });

  final VoidCallback onLogout;
  final VoidCallback? onDelete;
  final String email;
  final bool busy;
  final String? deleteHint;

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
            const AppText('Email Google', variant: AppTextVariant.label),
            AppText(email.isEmpty ? 'Belum masuk' : email),
            AppButton(
              'Hapus akun',
              icon: AppIcons.delete,
              variant: AppButtonVariant.destructiveOutline,
              onPressed: busy ? null : onDelete,
            ),
            if (deleteHint != null) AppText(deleteHint!, variant: AppTextVariant.caption),
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
