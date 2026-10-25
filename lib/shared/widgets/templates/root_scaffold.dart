import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
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

    this.onAccount,
    this.onTabSelected,
    this.onCreate,
  });

  final String title, accountLabel;
  final int activeIndex;
  final Widget body;
  final SyncState syncState;

  final VoidCallback? onAccount, onCreate;
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
      onCreate: onCreate,
    ),
  );
}
