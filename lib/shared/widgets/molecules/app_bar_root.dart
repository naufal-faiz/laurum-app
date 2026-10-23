import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
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
  });
  final String title, accountLabel;
  final Widget syncIndicator;
  final VoidCallback? onAccount;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: AppMoleculeStyles.appBar,
    child: SafeArea(
      bottom: false,
      child: SizedBox(
        height: AppSpacing.appBarHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Row(
            spacing: AppMoleculeTokens.gap,
            children: [
              Expanded(
                child: AppText(
                  title,
                  variant: AppTextVariant.titleSub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              syncIndicator,
              AppIconButton(AppIcons.avatar, label: accountLabel, onPressed: onAccount),
            ],
          ),
        ),
      ),
    ),
  );
}
