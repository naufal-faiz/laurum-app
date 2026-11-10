import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/brand_lockup.dart';
import 'package:widgetbook/widgetbook.dart';

final brandLockupUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const ColoredBox(
    color: AppColors.heroGradientStart,
    child: Padding(
      padding: EdgeInsets.all(AppSpacing.screenPadding),
      child: BrandLockup(name: 'LAURUM', tagline: 'LAUNDRY MANAGEMENT'),
    ),
  ),
);
