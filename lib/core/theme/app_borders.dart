import 'package:flutter/painting.dart';
import 'package:laurum/core/theme/app_colors.dart';

abstract final class AppBorders {
  // BorderSide defaults to one logical pixel, matching AppDimensions.line.
  static const card = Border.fromBorderSide(BorderSide(color: AppColors.border));
}
