import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_root.dart';
import 'package:laurum/shared/widgets/molecules/sync_indicator.dart';
import 'package:laurum/shared/widgets/organisms/bottom_nav_bar.dart';

class RootScaffold extends StatelessWidget {
  const RootScaffold({
    required this.title,
    required this.accountLabel,
    required this.activeIndex,
    required this.body,
    super.key,
    this.syncState = SyncState.tersimpan,
    this.fabLabel,
    this.onAccount,
    this.onTabSelected,
    this.onFab,
  }) : assert((fabLabel == null) == (onFab == null));

  final String title, accountLabel;
  final int activeIndex;
  final Widget body;
  final SyncState syncState;
  final String? fabLabel;
  final VoidCallback? onAccount, onFab;
  final ValueChanged<int>? onTabSelected;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(AppSpacing.appBarHeight),
      child: AppBarRoot(
        title: title,
        accountLabel: accountLabel,
        syncIndicator: SyncIndicator(state: syncState),
        onAccount: onAccount,
      ),
    ),
    body: body,
    bottomNavigationBar: BottomNavBar(
      activeIndex: activeIndex,
      onSelected: onTabSelected,
    ),
    floatingActionButton: fabLabel == null
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
