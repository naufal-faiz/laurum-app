import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/labeled_divider.dart';
import 'package:widgetbook/widgetbook.dart';

final labeledDividerUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const SingleChildScrollView(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        LabeledDivider('atau'),
        LabeledDivider('atau masuk dengan email'),
      ],
    ),
  ),
);
