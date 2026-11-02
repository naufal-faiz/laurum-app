import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class AccountDangerSection extends StatelessWidget {
  const AccountDangerSection({
    required this.busy,
    required this.offline,
    required this.onLogout,
    required this.onDelete,
    this.error,
    super.key,
  });
  final bool busy, offline;
  final VoidCallback onLogout, onDelete;
  final String? error;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.screenPadding,
    children: [
      if (error != null) BannerMessage(message: error!, variant: BannerMessageVariant.error),
      AppButton(
        'Keluar',
        icon: AppIcons.logout,
        variant: AppButtonVariant.destructiveOutline,
        onPressed: busy ? null : onLogout,
      ),
      const SectionHeader(title: 'Zona berbahaya'),
      const AppText('Hapus akun beserta seluruh data secara permanen.'),
      AppButton(
        'Hapus akun',
        icon: AppIcons.delete,
        variant: AppButtonVariant.destructiveOutline,
        onPressed: busy || offline ? null : onDelete,
      ),
      if (offline)
        const AppText('Hapus akun memerlukan koneksi internet.', variant: AppTextVariant.caption),
    ],
  );
}
