import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_search_field.dart';
import 'package:widgetbook/widgetbook.dart';

final appSearchFieldUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const SingleChildScrollView(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.cardGap,
      children: [
        AppSearchField(label: 'Search', clearLabel: 'Clear', hint: 'Search placeholder'),
        AppSearchField(label: 'Filled search', clearLabel: 'Clear', value: 'Sample query'),
        AppSearchField(
          label: 'Disabled search',
          clearLabel: 'Clear',
          value: 'Disabled',
          enabled: false,
        ),
      ],
    ),
  ),
);
