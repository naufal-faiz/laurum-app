import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:widgetbook/widgetbook.dart';

final chipBarUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        ChipBar(labels: const ['All', 'Active', 'Done'], selectedIndex: 0, onSelected: (_) {}),
        const ChipBar(labels: ['Disabled', 'Other']),
        ChipBar(
          labels: const ['A longer first label', 'Another long label', 'Third label'],
          onSelected: (_) {},
        ),
      ],
    ),
  ),
);
