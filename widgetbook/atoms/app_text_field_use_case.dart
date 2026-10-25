import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:widgetbook/widgetbook.dart';

final appTextFieldUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const SingleChildScrollView(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.cardGap,
      children: [
        AppTextField(label: 'Empty', hint: 'Placeholder'),
        AppTextField(label: 'Filled', value: 'Sample text', selectAllOnFocus: true),
        AppTextField(label: 'Error', value: 'Invalid', errorText: 'Error message'),
        AppTextField(label: 'Disabled', value: 'Disabled', enabled: false),
        AppTextField(label: 'Read only', value: 'Read only', readOnly: true),
        AppTextField(label: 'Password', value: 'secret', obscureText: true),
        AppTextField(label: 'Multiline', hint: 'Multiline', minLines: 2, maxLines: 4),
      ],
    ),
  ),
);
