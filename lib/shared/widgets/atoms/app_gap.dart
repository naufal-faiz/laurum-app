import 'package:flutter/widgets.dart';
import 'package:laurum/core/theme/app_spacing.dart';

class AppGap extends StatelessWidget {
  const AppGap({
    super.key,
    this.size = AppSpacing.cardGap,
    this.axis = Axis.vertical,
  }) : assert(size >= 0);

  final double size;
  final Axis axis;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: axis == Axis.horizontal ? size : 0,
    height: axis == Axis.vertical ? size : 0,
  );
}
