import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';
import 'package:widgetbook/widgetbook.dart';

final labeledFieldUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const SingleChildScrollView(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        LabeledField(
          label: 'Label',
          child: AppTextField(label: 'Label', hint: 'Input'),
        ),
        LabeledField(
          label: 'Helper',
          helperText: 'Guidance',
          child: AppTextField(label: 'Helper'),
        ),
        LabeledField(
          label: 'Error',
          errorText: 'Required',
          child: AppTextField(label: 'Error'),
        ),
        LabeledField(
          label: 'Field error',
          child: AppTextField(label: 'Error', errorText: 'Required'),
        ),
        LabeledField(
          label: 'Disabled',
          child: AppTextField(label: 'Disabled', enabled: false),
        ),
      ],
    ),
  ),
);
