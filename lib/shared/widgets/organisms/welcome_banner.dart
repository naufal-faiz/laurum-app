import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/icons/app_svgs.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/icon_tile.dart';

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
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: const BoxDecoration(
      borderRadius: AppRadius.cardLarge,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.primary, AppColors.primaryInk],
      ),
    ),
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 168),
      child: Stack(
        children: [
          for (final blob in const [
            (right: -63.0, top: -55.0, size: 170.0, color: AppColors.heroBlob),
            (right: -30.0, top: 62.0, size: 90.0, color: AppColors.heroBlobSoft),
          ])
            Positioned(
              right: blob.right,
              top: blob.top,
              width: blob.size,
              height: blob.size,
              child: DecoratedBox(
                decoration: BoxDecoration(color: blob.color, shape: BoxShape.circle),
              ),
            ),
          const Positioned(
            right: 22,
            top: 38,
            child: IconTile(
              icon: AppIcons.droplet,
              size: 64,
              iconSize: 26,
              background: AppColors.heroBlobSoft,
              foreground: AppColors.surface,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.largeX),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.large,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xxlarge * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacing.xxsmall,
                    children: [
                      AppText(
                        greeting,
                        variant: AppTextVariant.label,
                        color: AppColors.heroTagline,
                      ),
                      AppText(
                        businessName,
                        variant: AppTextVariant.titleSub,
                        color: AppColors.surface,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      AppText(
                        subtitle,
                        variant: AppTextVariant.caption,
                        color: AppColors.heroTagline,
                      ),
                    ],
                  ),
                ),
                AppButton(
                  actionLabel,
                  variant: AppButtonVariant.secondary,
                  size: AppButtonSize.small,
                  iconAsset: AppSvgs.cursorBack,
                  iconQuarterTurns: 2,
                  iconPlacement: AppButtonIconPlacement.trailing,
                  onPressed: onAction,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
