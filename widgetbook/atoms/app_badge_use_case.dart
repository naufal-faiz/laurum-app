import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:widgetbook/widgetbook.dart';

final appBadgeUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.cardGap,
      children: [
        for (final variant in AppBadgeVariant.values)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.cardGap),
            child: AppBadge(variant.name, variant: variant),
          ),
      ],
    ),
  ),
);
