import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/callout_ai.dart';
import 'package:widgetbook/widgetbook.dart';

final calloutAiUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const SingleChildScrollView(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        CalloutAi(message: 'Value to review'),
        CalloutAi(message: 'Alternative value', label: 'Review', icon: AppIcons.alert),
      ],
    ),
  ),
);
