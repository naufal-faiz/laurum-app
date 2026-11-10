import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/create_action.dart';
import 'package:laurum/shared/widgets/molecules/nav_item.dart';

/// Floating navigation pill of frames `LAURUM · Beranda`/`Antrean` (342x64).
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    required this.activeIndex,
    super.key,
    this.onSelected,
    this.onCreate,
    this.createLabel = 'Transaksi',
  }) : assert(activeIndex >= 0 && activeIndex < 4);
  final int activeIndex;
  final ValueChanged<int>? onSelected;
  final VoidCallback? onCreate;
  final String createLabel;
  static const _tabs = [
    ('Beranda', AppIcons.home, AppIcons.homeActive),
    ('Antrean', AppIcons.queue, AppIcons.queueActive),
    ('Pelanggan', AppIcons.customers, AppIcons.customersActive),
    ('Lainnya', AppIcons.menu, AppIcons.menuActive),
  ];
  int slotOf(int index) => index < 2 ? index : index + 1;
  bool selected(int slot) => slot != 2 && activeIndex == (slot > 2 ? slot - 1 : slot);
  VoidCallback? action(int slot) {
    if (slot == 2) return onCreate;
    return onSelected == null ? null : () => onSelected!(slot > 2 ? slot - 1 : slot);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scale = media.textScaler.clamp(maxScaleFactor: 1.3).scale(1);
    final barHeight = AppDimensions.navBarHeight * scale;
    final items = [
      for (final (index, tab) in _tabs.indexed)
        NavItem(
          label: tab.$1,
          icon: tab.$2,
          activeIcon: tab.$3,
          selected: selected(slotOf(index)),
          onTap: action(slotOf(index)),
        ),
    ];
    return MediaQuery(
      data: media.copyWith(textScaler: media.textScaler.clamp(maxScaleFactor: 1.3)),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: AppSpacing.small),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.small),
          child: SizedBox(
            height: barHeight + AppDimensions.navCreateLift,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: barHeight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.borderStrong),
                      borderRadius: AppRadius.cardLarge,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxsmall),
                      child: Row(
                        children: [
                          Expanded(child: items[0]),
                          Expanded(child: items[1]),
                          const Expanded(child: SizedBox()),
                          Expanded(child: items[2]),
                          Expanded(child: items[3]),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CreateAction(label: createLabel, onPressed: onCreate),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
