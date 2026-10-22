import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_borders.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';

enum AppCardRail { none, warning, error }

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    super.key,
    this.rail = AppCardRail.none,
    this.padding = const EdgeInsets.all(AppSpacing.cardPadding),
  });

  final Widget child;
  final AppCardRail rail;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: AppRadius.card,
    child: DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: AppBorders.card,
        borderRadius: AppRadius.card,
      ),
      child: Stack(
        children: [
          Padding(padding: padding, child: child),
          if (rail != AppCardRail.none)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: AppSpacing.railWidth,
              child: ColoredBox(
                color: rail == AppCardRail.warning ? AppColors.warningBorder : AppColors.error,
              ),
            ),
        ],
      ),
    ),
  );
}
