import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:widgetbook/widgetbook.dart';

final appCardUseCase = WidgetbookUseCase(
  name: 'Rail status, elevated, muted',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final rail in AppCardRail.values)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.cardGap),
            child: AppCard(
              rail: rail,
              child: AppText(rail.name, variant: AppTextVariant.bodyStrong),
            ),
          ),
        const AppCard(
          style: AppCardStyle.elevated,
          child: AppText('elevated', variant: AppTextVariant.bodyStrong),
        ),
        const AppCard(style: AppCardStyle.muted, child: AppText('muted')),
      ],
    ),
  ),
);
