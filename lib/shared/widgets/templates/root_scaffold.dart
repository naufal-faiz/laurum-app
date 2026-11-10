import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
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
    this.showAppBar = true,
    this.header,
    this.onAccount,
    this.onTabSelected,
    this.onCreate,
  });
  final String title, accountLabel;
  final int activeIndex;
  final Widget body;
  final SyncState syncState;
  final bool showAppBar;
  final Widget? header;
  final VoidCallback? onAccount, onCreate;
  final ValueChanged<int>? onTabSelected;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    appBar: showAppBar || header != null
        ? PreferredSize(
            preferredSize: Size.fromHeight(
              AppSpacing.appBarHeight *
                  (header == null ? 1 : MediaQuery.textScalerOf(context).scale(1)),
            ),
            child: header != null
                ? SafeArea(
                    bottom: false,
                    child: SizedBox(
                      height: AppSpacing.appBarHeight * MediaQuery.textScalerOf(context).scale(1),
                      child: header,
                    ),
                  )
                : AppBarRoot(
                    title: title,
                    accountLabel: accountLabel,
                    syncIndicator: SyncIndicator(state: syncState),
                    onAccount: onAccount,
                  ),
          )
        : null,
    extendBody: true,
    body: Builder(
      builder: (context) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(
            padding: media.padding.copyWith(
              bottom: (media.padding.bottom - AppDimensions.navCreateLift).clamp(
                0,
                double.infinity,
              ),
            ),
          ),
          child: body,
        );
      },
    ),
    bottomNavigationBar: BottomNavBar(
      activeIndex: activeIndex,
      onSelected: onTabSelected,
      onCreate: onCreate,
    ),
  );
}
