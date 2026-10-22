import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_chip.dart';
import 'package:widgetbook/widgetbook.dart';

final appChipUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.cardGap,
      children: [
        for (final selected in [false, true]) ...[
          AppChip(selected ? 'Selected' : 'Idle', selected: selected, onPressed: () {}),
          AppChip(selected ? 'Selected disabled' : 'Idle disabled', selected: selected),
        ],
      ],
    ),
  ),
);
