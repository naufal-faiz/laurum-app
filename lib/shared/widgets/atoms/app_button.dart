import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_button_styles.dart';
import 'package:laurum/core/theme/app_control_tokens.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_svg.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

export 'package:laurum/core/theme/app_button_styles.dart' show AppButtonSize, AppButtonVariant;

enum AppButtonIconPlacement { leading, trailing }

class AppButton extends StatelessWidget {
  const AppButton(
    this.label, {
    super.key,
    this.variant = AppButtonVariant.cta,
    this.size,
    this.icon,
    this.iconAsset,
    this.iconPlacement = AppButtonIconPlacement.leading,
    this.iconSize = AppDimensions.iconSmall,
    this.busy = false,
    this.onPressed,
  }) : assert(
         icon == null || iconAsset == null,
         'Use either icon or iconAsset, not both.',
       );
  final String label;
  final AppButtonVariant variant;
  final AppButtonSize? size;
  final AppIcons? icon;
  final String? iconAsset;
  final AppButtonIconPlacement iconPlacement;
  final double iconSize;
  final bool busy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final disabled = busy || onPressed == null;
    final foreground = disabled
        ? AppControlTokens.disabledForeground
        : AppButtonStyles.foreground(variant);
    final leading = iconAsset != null
        ? AppSvg(iconAsset!, size: iconSize, color: foreground)
        : icon == null
        ? null
        : AppIcon(icon!, size: iconSize, color: foreground);
    return TextButton(
      onPressed: disabled ? null : onPressed,
      style: AppButtonStyles.of(variant, size: size),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null && iconPlacement == AppButtonIconPlacement.leading) ...[
            leading,
            if (label.isNotEmpty) const SizedBox(width: AppControlTokens.iconGap),
          ],
          Flexible(
            child: AppText(
              label,
              textAlign: TextAlign.center,
              variant: variant == AppButtonVariant.cta || variant == AppButtonVariant.secondary
                  ? AppTextVariant.cta
                  : AppTextVariant.bodyStrong,
              color: foreground,
            ),
          ),
          if (leading != null && iconPlacement == AppButtonIconPlacement.trailing) ...[
            if (label.isNotEmpty) const SizedBox(width: AppControlTokens.iconGap),
            leading,
          ],
        ],
      ),
    );
  }
}
