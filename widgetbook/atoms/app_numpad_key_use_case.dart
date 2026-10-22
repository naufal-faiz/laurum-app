import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_input_styles.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_numpad_key.dart';
import 'package:widgetbook/widgetbook.dart';

final appNumpadKeyUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.cardGap,
      children: [
        Wrap(
          spacing: AppSpacing.cardGap,
          runSpacing: AppSpacing.cardGap,
          children: [
            for (final value in AppNumpadKeyValue.values)
              SizedBox(
                width: AppInputStyles.skeletonShort,
                child: AppNumpadKey(
                  value,
                  semanticLabel: value == AppNumpadKeyValue.backspace ? 'Delete' : null,
                  onPressed: () {},
                ),
              ),
            const SizedBox(
              width: AppInputStyles.skeletonShort,
              child: AppNumpadKey(AppNumpadKeyValue.one),
            ),
          ],
        ),
      ],
    ),
  ),
);
