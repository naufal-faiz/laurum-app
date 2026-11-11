import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/icons/app_svgs.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_styles.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

enum AppBarSubVariant { standard, detail }

class AppBarSub extends StatelessWidget {
  const AppBarSub({
    required this.title,
    required this.backLabel,
    super.key,
    this.onBack,
    this.trailing,
    this.subtitle,
    this.variant = AppBarSubVariant.standard,
  });
  final String title, backLabel;
  final VoidCallback? onBack;
  final Widget? trailing;
  final String? subtitle;
  final AppBarSubVariant variant;
  @override
  Widget build(BuildContext context) {
    final detail = variant == AppBarSubVariant.detail;
    final back = AppIconButton(
      icon: detail ? null : AppIcons.back,
      iconAsset: detail ? AppSvgs.cursorBack : null,
      label: backLabel,
      color: detail ? AppColors.primary : AppColors.ink,
      onPressed: onBack,
    );
    final heading = AppText(
      title,
      variant: AppTextVariant.titleSub,
      color: detail ? AppColors.primaryInk : AppColors.ink,
      maxLines: detail ? null : 1,
      overflow: detail ? null : TextOverflow.ellipsis,
    );
    return DecoratedBox(
      decoration: AppMoleculeStyles.appBar,
      child: SafeArea(
        bottom: false,
        child: detail
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.small,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppMoleculeTokens.gap,
                  children: [
                    AppCard(style: AppCardStyle.muted, padding: EdgeInsets.zero, child: back),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: AppSpacing.xxsmall,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: AppSpacing.small,
                            runSpacing: AppSpacing.xxsmall,
                            children: [heading, ?trailing],
                          ),
                          if (subtitle != null)
                            AppText(
                              subtitle!,
                              variant: AppTextVariant.caption,
                              color: AppColors.ink3,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox(
                height: AppSpacing.appBarHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                  child: Row(
                    spacing: AppMoleculeTokens.gap,
                    children: [
                      back,
                      Expanded(child: heading),
                      ?trailing,
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
