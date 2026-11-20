import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_root.dart';
import 'package:laurum/shared/widgets/molecules/sync_indicator.dart';
import 'package:laurum/shared/widgets/organisms/app_data_refresh.dart';
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
    this.headerHeight = AppSpacing.appBarHeight,
    this.onAccount,
    this.onTabSelected,
    this.onCreate,
    this.subtitle,
    this.pageHeader,
    this.onRefresh,
    this.refreshScrollable = true,
  });
  final String title, accountLabel;
  final String? subtitle;
  final int activeIndex;
  final Widget body;
  final SyncState syncState;
  final bool showAppBar;
  final Widget? header, pageHeader;
  final double headerHeight;
  final VoidCallback? onAccount, onCreate;
  final ValueChanged<int>? onTabSelected;
  final Future<void> Function()? onRefresh;
  final bool refreshScrollable;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    appBar: pageHeader == null && (showAppBar || header != null)
        ? PreferredSize(
            preferredSize: Size.fromHeight(
              headerHeight *
                  (header == null && subtitle == null
                      ? 1
                      : MediaQuery.textScalerOf(context).scale(1)),
            ),
            child: header != null
                ? SafeArea(
                    bottom: false,
                    child: SizedBox(
                      height: headerHeight * MediaQuery.textScalerOf(context).scale(1),
                      child: header,
                    ),
                  )
                : AppBarRoot(
                    title: title,
                    subtitle: subtitle,
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
        final bottom = (media.padding.bottom - AppDimensions.navCreateLift).clamp(
          0.0,
          double.infinity,
        );
        return MediaQuery(
          data: media.copyWith(padding: media.padding.copyWith(bottom: bottom)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (pageHeader != null) SafeArea(bottom: false, child: pageHeader!),
              Expanded(
                child: onRefresh == null
                    ? body
                    : AppDataRefresh(
                        onRefresh: onRefresh!,
                        hasScrollableChild: refreshScrollable,
                        child: body,
                      ),
              ),
            ],
          ),
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
