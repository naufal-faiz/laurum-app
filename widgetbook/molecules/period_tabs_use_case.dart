import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/period_tabs.dart';
import 'package:widgetbook/widgetbook.dart';

final periodTabsUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        for (var selected = 0; selected < 3; selected++)
          PeriodTabs(
            labels: const ['Day', 'Week', 'Month'],
            selectedIndex: selected,
            onSelected: (_) {},
          ),
        const PeriodTabs(labels: ['Disabled', 'Other'], selectedIndex: 0),
      ],
    ),
  ),
);
