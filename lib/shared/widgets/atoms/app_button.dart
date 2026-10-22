import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_button_styles.dart';
import 'package:laurum/core/theme/app_control_tokens.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

export 'package:laurum/core/theme/app_button_styles.dart' show AppButtonVariant;

class AppButton extends StatelessWidget {
  const AppButton(
    this.label, {
    super.key,
    this.variant = AppButtonVariant.cta,
    this.icon,
    this.onPressed,
  });
  final String label;
  final AppButtonVariant variant;
  final AppIcons? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final foreground = onPressed == null
        ? AppControlTokens.disabledForeground
        : AppButtonStyles.foreground(variant);
    return TextButton(
      onPressed: onPressed,
      style: AppButtonStyles.of(variant),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            AppIcon(icon!, size: AppDimensions.iconAction, color: foreground),
            const SizedBox(width: AppControlTokens.iconGap),
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
