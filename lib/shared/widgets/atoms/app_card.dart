import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_borders.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_shadows.dart';
import 'package:laurum/core/theme/app_spacing.dart';

enum AppCardRail { none, warning, error }

/// `outlined` = border tipis tanpa bayangan; `elevated` = radius 24 + shadow.
enum AppCardStyle { outlined, elevated }

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    super.key,
    this.style = AppCardStyle.outlined,
    this.rail = AppCardRail.none,
    this.padding = const EdgeInsets.all(AppSpacing.cardPadding),
  });

  final Widget child;
  final AppCardStyle style;
  final AppCardRail rail;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final elevated = style == AppCardStyle.elevated;
    final radius = elevated ? AppRadius.cardLarge : AppRadius.card;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: elevated ? null : AppBorders.card,
        borderRadius: radius,
        boxShadow: elevated ? AppShadows.cardElevated : null,
      ),
      child: ClipRRect(
        borderRadius: radius,
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
}
