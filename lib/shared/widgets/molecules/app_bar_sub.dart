import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_styles.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class AppBarSub extends StatelessWidget {
  const AppBarSub({
    required this.title,
    required this.backLabel,
    super.key,
    this.onBack,
    this.trailing,
  });
  final String title, backLabel;
  final VoidCallback? onBack;
  final Widget? trailing;
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
              AppIconButton(
                AppIcons.back,
                label: backLabel,
                color: AppColors.ink,
                onPressed: onBack,
              ),
              Expanded(
                child: AppText(
                  title,
                  variant: AppTextVariant.titleSub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    ),
  );
}
