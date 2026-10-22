import 'package:flutter/widgets.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';

class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    super.key,
    this.size = AppDimensions.icon,
    this.color = AppColors.ink2,
    this.semanticLabel,
  });

  final AppIcons icon;
  final double size;
  final Color color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Icon(
    icon.data,
    size: size,
    color: color,
    semanticLabel: semanticLabel,
  );
}
