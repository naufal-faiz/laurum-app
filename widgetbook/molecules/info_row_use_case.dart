import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/info_row.dart';
import 'package:widgetbook/widgetbook.dart';

final infoRowUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const SingleChildScrollView(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        InfoRow(label: 'Label', value: 'Value'),
        InfoRow(label: 'With icon', value: 'Value', icon: AppIcons.info),
      ],
    ),
  ),
);
