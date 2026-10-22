import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/stat_tile.dart';
import 'package:widgetbook/widgetbook.dart';

final statTileUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const SingleChildScrollView(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        StatTile(label: 'Metric', value: 'Value'),
        StatTile(
          label: 'Metric with detail',
          value: 'Value',
          description: 'Description',
          icon: AppIcons.wallet,
        ),
      ],
    ),
  ),
);
