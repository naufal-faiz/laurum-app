import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

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
  static final _ring = Border.all(color: AppColors.surface, width: AppSpacing.railWidth);
  static const _tabs = [
    ('Antrean', AppIcons.queue, AppIcons.queueActive),
    ('Pelanggan', AppIcons.customers, AppIcons.customersActive),
    ('Transaksi', AppIcons.add, AppIcons.add),
    ('Laporan', AppIcons.reports, AppIcons.reportsActive),
    ('Lainnya', AppIcons.menu, AppIcons.menuActive),
  ];
  bool selected(int slot) => slot != 2 && activeIndex == (slot > 2 ? slot - 1 : slot);
  VoidCallback? action(int slot) {
    if (slot == 2) return onCreate;
    return onSelected == null ? null : () => onSelected!(slot > 2 ? slot - 1 : slot);
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      const Positioned.fill(
        top: AppDimensions.navCreateLift,
        child: ColoredBox(color: AppColors.surface),
      ),
      const Positioned(top: AppDimensions.navCreateLift, left: 0, right: 0, child: AppDivider()),
      SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var slot = 0; slot < _tabs.length; slot++)
              Expanded(
                child: Semantics(
                  label: slot == 2 ? 'Transaksi baru' : _tabs[slot].$1,
                  button: true,
                  selected: selected(slot),
                  excludeSemantics: true,
                  onTap: action(slot),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: action(slot),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: slot == 2 ? 0 : AppDimensions.navCreateLift + AppMoleculeTokens.gap,
                        bottom: AppMoleculeTokens.gap,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (slot == 2)
                            Container(
                              width: AppDimensions.navCreateSize,
                              height: AppDimensions.navCreateSize,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: _ring,
                              ),
                              child: const AppIcon(AppIcons.add, color: AppColors.onPrimary),
                            )
                          else
                            AppIcon(
                              selected(slot) ? _tabs[slot].$3 : _tabs[slot].$2,
                              color: selected(slot) ? AppColors.primary : AppColors.ink2,
                            ),
                          const SizedBox(height: AppMoleculeTokens.smallGap),
                          AppText(
                            slot == 2 ? createLabel : _tabs[slot].$1,
                            textAlign: TextAlign.center,
                            variant: selected(slot) ? AppTextVariant.label : AppTextVariant.caption,
                            color: selected(slot) ? AppColors.primary : AppColors.ink2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ],
  );
}
