import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';

class AccountPasswordSection extends StatelessWidget {
  const AccountPasswordSection({
    required this.usesPassword,
    required this.busy,
    required this.onPassword,
    super.key,
  });
  final bool usesPassword, busy;
  final VoidCallback onPassword;

  @override
  Widget build(BuildContext context) => usesPassword
      ? MenuRow(
          label: 'Ganti password',
          subtitle: 'Kata sandi akun ini',
          icon: AppIcons.lock,
          compact: true,
          onTap: busy ? null : onPassword,
        )
      : const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.mediumLarge,
            vertical: AppSpacing.xsmall,
          ),
          child: Row(
            spacing: AppSpacing.cardGap,
            children: [
              AppIcon(
                AppIcons.lock,
                size: AppDimensions.iconSmall,
                color: AppColors.primary,
                boxed: true,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
              SizedBox(width: AppDimensions.iconAction),
            ],
          ),
        );
}
