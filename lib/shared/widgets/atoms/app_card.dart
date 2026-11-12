import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_borders.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_shadows.dart';
import 'package:laurum/core/theme/app_spacing.dart';

enum AppCardRail { none, warning, error, info, success }

/// `outlined` = border tipis tanpa bayangan; `elevated` = radius 24 + shadow.
enum AppCardStyle { outlined, elevated, muted, primary, success }

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    super.key,
    this.style = AppCardStyle.outlined,
    this.rail = AppCardRail.none,
    this.bubble = false,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.cardPadding),
  });
  final Widget child;
  final AppCardStyle style;
  final AppCardRail rail;
  final bool bubble;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) {
    final elevated = style == AppCardStyle.elevated;
    final muted = style == AppCardStyle.muted;
    final primary = style == AppCardStyle.primary;
    final success = style == AppCardStyle.success;
    final radius = elevated
        ? AppRadius.cardLarge
        : muted
        ? AppRadius.action
        : AppRadius.card;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: switch (style) {
          AppCardStyle.primary => AppColors.primary,
          AppCardStyle.success => AppColors.successTint,
          AppCardStyle.muted => AppColors.surfaceLow,
          _ => AppColors.surface,
        },
        border: elevated || muted || primary || success ? null : AppBorders.card,
        borderRadius: radius,
        boxShadow: elevated ? AppShadows.cardElevated : null,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              children: [
                if (bubble)
                  const Positioned(
                    top: -AppSpacing.xxlarge,
                    right: -AppSpacing.touchTarget,
                    width: AppSpacing.touchTarget * 3,
                    height: AppSpacing.touchTarget * 3,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: AppColors.heroBlob, shape: BoxShape.circle),
                    ),
                  ),
                Padding(padding: padding, child: child),
                if (rail != AppCardRail.none)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: AppSpacing.railWidth,
                    child: ColoredBox(
                      color: switch (rail) {
                        AppCardRail.warning => AppColors.warningBorder,
                        AppCardRail.error => AppColors.error,
                        AppCardRail.success => AppColors.success,
                        _ => AppColors.primary,
                      },
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
