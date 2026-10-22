import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_gap.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:widgetbook/widgetbook.dart';

final appGapUseCase = WidgetbookUseCase(
  name: 'Vertikal dan horizontal',
  builder: (context) => const Padding(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Jarak vertikal'),
        AppGap(),
        AppText('Jarak kartu'),
        AppGap(size: AppSpacing.screenPadding),
        Row(
          children: [
            AppText('Kiri'),
            AppGap(axis: Axis.horizontal),
            AppText('Kanan'),
          ],
        ),
      ],
    ),
  ),
);
