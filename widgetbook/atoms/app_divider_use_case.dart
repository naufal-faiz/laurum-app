import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_gap.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:widgetbook/widgetbook.dart';

final appDividerUseCase = WidgetbookUseCase(
  name: 'Horizontal dan vertikal',
  builder: (context) => const Padding(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Pemisah horizontal'),
        AppGap(),
        AppDivider(),
        AppGap(),
        SizedBox(
          height: AppSpacing.touchTarget,
          child: Row(
            children: [
              AppText('Kiri'),
              AppGap(axis: Axis.horizontal),
              AppDivider(axis: Axis.vertical),
              AppGap(axis: Axis.horizontal),
              AppText('Kanan'),
            ],
          ),
        ),
      ],
    ),
  ),
);
