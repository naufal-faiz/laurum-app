import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/stepper_field.dart';
import 'package:widgetbook/widgetbook.dart';

final stepperFieldUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        StepperField(
          value: 'Value',
          decreaseLabel: 'Decrease',
          increaseLabel: 'Increase',
          editLabel: 'Edit',
          onDecrease: () {},
          onIncrease: () {},
          onEdit: () {},
        ),
        const StepperField(
          value: 'Disabled',
          decreaseLabel: 'Decrease',
          increaseLabel: 'Increase',
          editLabel: 'Edit',
        ),
        StepperField(
          value: 'Minimum',
          decreaseLabel: 'Decrease',
          increaseLabel: 'Increase',
          editLabel: 'Edit',
          onIncrease: () {},
        ),
      ],
    ),
  ),
);
