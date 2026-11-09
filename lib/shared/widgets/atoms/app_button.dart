import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_button_styles.dart';
import 'package:laurum/core/theme/app_control_tokens.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_svg.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

export 'package:laurum/core/theme/app_button_styles.dart' show AppButtonVariant;

class AppButton extends StatelessWidget {
  const AppButton(
    this.label, {
    super.key,
    this.variant = AppButtonVariant.cta,
    this.icon,
    this.iconAsset,
    this.onPressed,
  }) : assert(
         icon == null || iconAsset == null,
         'Use either icon or iconAsset, not both.',
       );
  final String label;
  final AppButtonVariant variant;
  final AppIcons? icon;
  final String? iconAsset;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final foreground = onPressed == null
        ? AppControlTokens.disabledForeground
        : AppButtonStyles.foreground(variant);
    final leading = iconAsset != null
        ? AppSvg(iconAsset!, size: AppDimensions.iconAction, color: foreground)
        : icon == null
        ? null
        : AppIcon(icon!, size: AppDimensions.iconAction, color: foreground);
    return TextButton(
      onPressed: onPressed,
      style: AppButtonStyles.of(variant),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) ...[
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
        ],
      ),
    );
  }
}
