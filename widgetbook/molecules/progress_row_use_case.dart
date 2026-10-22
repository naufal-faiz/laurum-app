import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/progress_row.dart';
import 'package:widgetbook/widgetbook.dart';

final progressRowUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        for (final p in [0.0, 0.5, 1.0])
          ProgressRow(label: 'Progress', value: 'Value', progress: p),
      ],
    ),
  ),
);
