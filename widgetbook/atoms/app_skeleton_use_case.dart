import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_input_styles.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:widgetbook/widgetbook.dart';

final appSkeletonUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const SingleChildScrollView(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.cardGap,
      children: [
        AppSkeleton(width: AppInputStyles.skeletonShort, height: 16),
        AppSkeleton(width: AppInputStyles.skeletonMedium, height: 22),
        AppSkeleton(),
        AppSkeleton(height: AppSpacing.touchTarget),
      ],
    ),
  ),
);
