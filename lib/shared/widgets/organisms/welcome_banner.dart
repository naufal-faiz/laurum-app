import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/icon_tile.dart';

/// Gradient welcome card of frame `LAURUM · Beranda` (342x148, radius 24).
class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({
    required this.greeting,
    required this.businessName,
    required this.subtitle,
    required this.actionLabel,
    super.key,
    this.onAction,
  });

  final String greeting, businessName, subtitle, actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: AppRadius.cardLarge,
    child: DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryInk],
        ),
      ),
      child: SizedBox(
        height: 148,
        child: Stack(
          children: [
            for (final blob in const [
              (right: -63.0, top: -55.0, width: 170.0, height: 170.0, color: AppColors.heroBlob),
              (right: -30.0, top: 62.0, width: 90.0, height: 90.0, color: AppColors.heroBlobSoft),
            ])
              Positioned(
                right: blob.right,
                top: blob.top,
                width: blob.width,
                height: blob.height,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: blob.color, shape: BoxShape.circle),
                ),
              ),
            const Positioned(
              right: 22,
              top: 34,
              child: IconTile(
                icon: AppIcons.droplet,
                size: 64,
                iconSize: 26,
                background: AppColors.heroBlobSoft,
                foreground: AppColors.surface,
              ),
            ),
            Positioned(
              left: AppSpacing.largeX,
              right: 96,
              top: AppSpacing.largeX,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    greeting,
                    variant: AppTextVariant.caption,
                    color: AppColors.heroTagline,
                  ),
                  AppText(
                    businessName,
                    variant: AppTextVariant.titleRoot,
                    color: AppColors.surface,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppText(
                    subtitle,
                    variant: AppTextVariant.caption,
                    color: AppColors.heroTagline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Positioned(
              left: AppSpacing.largeX,
              bottom: AppSpacing.mediumLarge,
              child: AppButton(
                actionLabel,
                variant: AppButtonVariant.secondary,
                size: AppButtonSize.small,
                icon: AppIcons.arrowForward,
                iconPlacement: AppButtonIconPlacement.trailing,
                onPressed: onAction,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
