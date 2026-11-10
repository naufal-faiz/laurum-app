import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

/// One slot of the floating bottom navigation pill (60x46, radius 14).
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
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryTint : AppColors.surface,
          borderRadius: AppRadius.cta,
        ),
        child: SizedBox(
          width: 60,
          height: 46,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4,
            children: [
              AppIcon(
                selected ? activeIcon ?? icon : icon,
                size: 21,
                color: selected ? AppColors.primary : AppColors.ink3,
              ),
              AppText(
                label,
                variant: selected ? AppTextVariant.label : AppTextVariant.caption,
                color: selected ? AppColors.primary : AppColors.ink3,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
