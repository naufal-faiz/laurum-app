import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_svgs.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/auth/state/account_view.dart';
import 'package:laurum/features/auth/widgets/account_password_section.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_svg.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

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
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  key: const ValueKey('account-password-row'),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xsmall),
                  child: AccountPasswordSection(
                    usesPassword: data.usesPassword,
                    busy: busy,
                    onPassword: onPassword,
                  ),
                ),
              ),
              const AppDivider(),
              Expanded(
                child: Padding(
                  key: const ValueKey('account-google-row'),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.mediumLarge,
                    vertical: AppSpacing.medium,
                  ),
                  child: Row(
                    spacing: AppSpacing.cardGap,
                    children: [
                      const SizedBox(
                        width: AppDimensions.iconSmall + AppSpacing.small * 2,
                        child: Center(child: AppSvg(AppSvgs.google, size: AppDimensions.iconSmall)),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: AppSpacing.xxsmall,
                          children: [
                            const AppText('Akun Google', variant: AppTextVariant.label),
                            AppText(
                              data.googleLinked ? 'Tertaut' : 'Tidak tertaut',
                              variant: AppTextVariant.caption,
                              color: data.googleLinked ? AppColors.successInk : AppColors.ink3,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppDimensions.iconAction),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
