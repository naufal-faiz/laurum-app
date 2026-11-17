import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/icons/app_svgs.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/auth/state/account_view.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_svg.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';

class AccountSecuritySection extends StatelessWidget {
  const AccountSecuritySection({
    required this.data,
    required this.busy,
    required this.onPassword,
    super.key,
  });
  final AccountView data;
  final bool busy;
  final VoidCallback onPassword;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.small,
    children: [
      const AppText('KEAMANAN', variant: AppTextVariant.label, color: AppColors.ink3),
      AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (data.usesPassword)
              MenuRow(
                label: 'Ganti password',
                subtitle: 'Kata sandi akun ini',
                icon: AppIcons.lock,
                compact: true,
                onTap: busy ? null : onPassword,
              )
            else
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.mediumLarge,
                  vertical: AppSpacing.smallMedium,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xxsmall,
                  children: [
                    AppText('Ganti password', variant: AppTextVariant.label),
                    AppText(
                      'Masuk dengan Google. Ganti password tidak tersedia.',
                      variant: AppTextVariant.caption,
                      color: AppColors.ink3,
                    ),
                  ],
                ),
              ),
            const AppDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.mediumLarge,
                vertical: AppSpacing.smallMedium,
              ),
              child: Row(
                spacing: AppSpacing.small,
                children: [
                  const AppSvg(AppSvgs.google, size: AppDimensions.iconAction),
                  const Expanded(
                    child: AppText('Akun Google', variant: AppTextVariant.label),
                  ),
                  AppText(
                    data.googleLinked ? 'Tertaut' : 'Tidak tertaut',
                    variant: AppTextVariant.label,
                    color: data.googleLinked ? AppColors.successInk : AppColors.ink3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
