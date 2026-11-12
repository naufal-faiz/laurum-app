import 'package:flutter/widgets.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_svg.dart';

class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    super.key,
    this.size = AppDimensions.icon,
    this.color = AppColors.ink2,
    this.semanticLabel,
    this.boxed = false,
    this.assetName,
    this.boxColor,
  });

  final AppIcons icon;
  final double size;
  final Color color;
  final String? semanticLabel;
  final bool boxed;
  final String? assetName;
  final Color? boxColor;

  @override
  Widget build(BuildContext context) {
    final glyph = assetName == null
        ? Icon(icon.data, size: size, color: color, semanticLabel: semanticLabel)
        : AppSvg(assetName!, size: size, color: color, semanticLabel: semanticLabel);
    return boxed
        ? Container(
            padding: const EdgeInsets.all(AppSpacing.small),
            decoration: BoxDecoration(
              color: boxColor ?? AppColors.primaryTint,
              border: boxColor == null ? null : Border.all(color: boxColor!),
              borderRadius: AppRadius.action,
            ),
            child: glyph,
          )
        : glyph;
  }
}
