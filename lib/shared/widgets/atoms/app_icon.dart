import 'package:flutter/widgets.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';

class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    super.key,
    this.size = AppDimensions.icon,
    this.color = AppColors.ink2,
    this.semanticLabel,
    this.boxed = false,
  });

  final AppIcons icon;
  final double size;
  final Color color;
  final String? semanticLabel;
  final bool boxed;

  @override
  Widget build(BuildContext context) {
    final glyph = Icon(icon.data, size: size, color: color, semanticLabel: semanticLabel);
    return boxed
        ? Container(
            padding: const EdgeInsets.all(AppSpacing.small),
            decoration: const BoxDecoration(
              color: AppColors.primaryTint,
              borderRadius: AppRadius.action,
            ),
            child: glyph,
          )
        : glyph;
  }
}
