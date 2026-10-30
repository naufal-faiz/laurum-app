import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_sub.dart';

class SubScaffold extends StatelessWidget {
  const SubScaffold({
    required this.title,
    required this.backLabel,
    required this.body,
    super.key,
    this.onBack,
    this.trailing,
    this.fabLabel,
    this.onFab,
  }) : assert((fabLabel == null) == (onFab == null));

  final String title, backLabel;
  final Widget body;
  final VoidCallback? onBack, onFab;
  final String? fabLabel;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(AppSpacing.appBarHeight),
      child: AppBarSub(
        title: title,
        backLabel: backLabel,
        onBack: onBack,
        trailing: trailing,
      ),
    ),
    body: SafeArea(top: false, child: body),
    floatingActionButton: fabLabel == null || MediaQuery.viewInsetsOf(context).bottom > 0
        ? null
        : FloatingActionButton.extended(
            onPressed: onFab,
            elevation: 0,
            backgroundColor: AppColors.primary,
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.chip),
            extendedPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            icon: const AppIcon(
              AppIcons.add,
              size: AppDimensions.iconAction,
              color: AppColors.onPrimary,
            ),
            label: AppText(
              fabLabel!,
              variant: AppTextVariant.bodyStrong,
              color: AppColors.onPrimary,
            ),
          ),
  );
}
