import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_styles.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class AppBarRoot extends StatelessWidget {
  const AppBarRoot({
    required this.title,
    required this.accountLabel,
    required this.syncIndicator,
    super.key,
    this.onAccount,
    this.subtitle,
  });
  final String title, accountLabel;
  final Widget syncIndicator;
  final VoidCallback? onAccount;
  final String? subtitle;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: AppMoleculeStyles.appBar,
    child: SafeArea(
      bottom: false,
      child: SizedBox(
        height:
            AppSpacing.appBarHeight *
            (subtitle == null ? 1 : MediaQuery.textScalerOf(context).scale(1)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Row(
            spacing: AppMoleculeTokens.gap,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      title,
                      variant: AppTextVariant.titleSub,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null)
                      AppText(
                        subtitle!,
                        variant: AppTextVariant.caption,
                        color: AppColors.ink3,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              syncIndicator,
              AppIconButton(icon: AppIcons.avatar, label: accountLabel, onPressed: onAccount),
            ],
          ),
        ),
      ),
    ),
  );
}
