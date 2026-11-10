import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';

/// Decorative icon square/circle: coloured surface, radius and a centred icon.
class IconTile extends StatelessWidget {
  const IconTile({
    required this.icon,
    required this.size,
    required this.iconSize,
    super.key,
    this.background = AppColors.surface,
    this.foreground = AppColors.primary,
    this.radius = AppRadius.chip,
  });

  /// White 38 logo tile of the auth hero (icon 18, radius 12).
  const IconTile.logo({super.key})
    : icon = AppIcons.droplet,
      size = 38,
      iconSize = 18,
      background = AppColors.surface,
      foreground = AppColors.primary,
      radius = AppRadius.logo;

  /// Blue 118 circle with the shirt illustration of `LAURUM · Masuk`.
  const IconTile.illustration({super.key})
    : icon = AppIcons.service,
      size = 118,
      iconSize = 44,
      background = AppColors.illustration,
      foreground = AppColors.surface,
      radius = AppRadius.chip;

  final AppIcons icon;
  final double size, iconSize;
  final Color background, foreground;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(color: background, borderRadius: radius),
    child: SizedBox.square(
      dimension: size,
      child: Center(
        child: AppIcon(icon, size: iconSize, color: foreground),
      ),
    ),
  );
}
