import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';

class AppSvg extends StatelessWidget {
  const AppSvg(
    this.assetName, {
    super.key,
    this.size = AppDimensions.icon,
    this.color = AppColors.ink2,
    this.semanticLabel,
  });

  final String assetName;
  final double size;
  final Color color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    assetName,
    width: size,
    height: size,
    theme: SvgTheme(currentColor: color),
    semanticsLabel: semanticLabel,
    excludeFromSemantics: semanticLabel == null,
  );
}
