import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_input_styles.dart';
import 'package:laurum/core/theme/app_radius.dart';

class AppSkeleton extends StatelessWidget {
  const AppSkeleton({
    super.key,
    this.width = double.infinity,
    this.height = AppInputStyles.skeletonHeight,
  }) : assert(width > 0),
       assert(height > 0 && height < double.infinity);
  final double width, height;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(
      width: width,
      height: height,
      child: const DecoratedBox(
        decoration: BoxDecoration(color: AppColors.chipIdle, borderRadius: AppRadius.input),
      ),
    ),
  );
}
