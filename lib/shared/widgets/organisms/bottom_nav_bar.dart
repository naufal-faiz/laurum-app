import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({required this.activeIndex, super.key, this.onSelected})
    : assert(activeIndex >= 0 && activeIndex < 5);
  final int activeIndex;
  final ValueChanged<int>? onSelected;
  static const _tabs = [
    ('Antrean', AppIcons.queue, AppIcons.queueActive),
    ('Pelanggan', AppIcons.customers, AppIcons.customersActive),
    ('Transaksi', AppIcons.receipt, AppIcons.receiptActive),
    ('Laporan', AppIcons.reports, AppIcons.reportsActive),
    ('Lainnya', AppIcons.menu, AppIcons.menuActive),
  ];
  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.surface,
    child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppDivider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < _tabs.length; i++)
                Expanded(
                  child: Semantics(
                    selected: activeIndex == i,
                    child: InkWell(
                      onTap: onSelected == null ? null : () => onSelected!(i),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: AppSpacing.touchTarget),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppMoleculeTokens.gap),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppIcon(
                                activeIndex == i ? _tabs[i].$3 : _tabs[i].$2,
                                color: activeIndex == i ? AppColors.primary : AppColors.ink2,
                              ),
                              const SizedBox(height: AppMoleculeTokens.smallGap),
                              AppText(
                                _tabs[i].$1,
                                textAlign: TextAlign.center,
                                variant: activeIndex == i
                                    ? AppTextVariant.label
                                    : AppTextVariant.caption,
                                color: activeIndex == i ? AppColors.primary : AppColors.ink2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}
