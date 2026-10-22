import 'package:flutter/widgets.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key, this.axis = Axis.horizontal});

  final Axis axis;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: axis == Axis.vertical ? AppDimensions.line : double.infinity,
    height: axis == Axis.horizontal ? AppDimensions.line : double.infinity,
    child: const ColoredBox(color: AppColors.border),
  );
}
