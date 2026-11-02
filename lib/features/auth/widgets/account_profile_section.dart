import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/auth/state/account_view.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/info_row.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';

class AccountProfileSection extends StatelessWidget {
  const AccountProfileSection({
    required this.data,
    required this.busy,
    required this.onName,
    required this.onPhone,
    required this.onPassword,
    super.key,
  });
  final AccountView data;
  final bool busy;
  final VoidCallback onName, onPhone, onPassword;
  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        MenuRow(
          label: 'Nama',
          subtitle: data.name.isEmpty ? 'Belum diisi' : data.name,
          icon: AppIcons.person,
          onTap: busy ? null : onName,
        ),
        const AppDivider(),
        const AppText('Email', variant: AppTextVariant.label),
        AppText(data.email, variant: AppTextVariant.bodyStrong),
        const AppText('Ganti email belum tersedia', variant: AppTextVariant.caption),
        const AppDivider(),
        MenuRow(
          label: 'No. telp',
          subtitle: data.phone.isEmpty ? 'Belum diisi' : Formatters.telepon(data.phone),
          icon: AppIcons.phone,
          onTap: busy ? null : onPhone,
        ),
        const AppText('Opsional, tanpa OTP', variant: AppTextVariant.caption),
        const AppDivider(),
        if (data.usesPassword)
          MenuRow(label: 'Ganti password', icon: AppIcons.lock, onTap: busy ? null : onPassword)
        else ...[
          const AppText('Ganti password', variant: AppTextVariant.bodyStrong),
          const AppText(
            'Masuk dengan Google. Ganti password tidak tersedia.',
            variant: AppTextVariant.caption,
          ),
        ],
        const AppDivider(),
        InfoRow(label: 'Akun Google', value: data.googleLinked ? 'Tertaut' : 'Tidak tertaut'),
      ],
    ),
  );
}
