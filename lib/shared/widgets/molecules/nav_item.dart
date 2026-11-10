import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

/// A flexible navigation slot, selected by icon and text colour.
class NavItem extends StatelessWidget {
  const NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    super.key,
    this.activeIcon,
    this.onTap,
  });
  final String label;
  final AppIcons icon;
  final AppIcons? activeIcon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    button: true,
    selected: selected,
    excludeSemantics: true,
    onTap: onTap,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 60, minHeight: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 4,
          children: [
            AppIcon(
              selected ? activeIcon ?? icon : icon,
              size: 23,
              color: selected ? AppColors.primary : AppColors.ink3,
            ),
            AppText(
              label,
              variant: selected ? AppTextVariant.label : AppTextVariant.caption,
              color: selected ? AppColors.primary : AppColors.ink3,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
