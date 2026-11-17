import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/auth/state/account_view.dart';
import 'package:laurum/features/auth/widgets/account_email_section.dart';
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

  /// Teks statis sejajar dengan teks MenuRow (ikon kotak 32 + jarak 12).
  static const _rowTextInset =
      AppSpacing.mediumLarge + AppSpacing.small * 2 + AppDimensions.iconSmall + AppSpacing.cardGap;

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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xsmall),
              child: MenuRow(
                label: 'Nama',
                subtitle: data.name.isEmpty ? 'Belum diisi' : data.name,
                icon: AppIcons.person,
                compact: true,
                onTap: busy ? null : onName,
              ),
            ),
            const AppDivider(),
            AccountEmailSection(email: data.email),
            const AppDivider(),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xsmall, bottom: AppSpacing.xxsmall),
              child: MenuRow(
                label: 'No. telp',
                subtitle: data.phone.isEmpty ? 'Belum diisi' : Formatters.telepon(data.phone),
                icon: AppIcons.phone,
                compact: true,
                onTap: busy ? null : onPhone,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: _rowTextInset,
                right: AppSpacing.mediumLarge,
                bottom: AppSpacing.medium,
              ),
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
