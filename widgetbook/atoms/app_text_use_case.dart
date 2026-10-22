import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:widgetbook/widgetbook.dart';

final appTextUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final variant in AppTextVariant.values)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.cardGap),
            child: AppText(variant.name, variant: variant),
          ),
      ],
    ),
  ),
);
