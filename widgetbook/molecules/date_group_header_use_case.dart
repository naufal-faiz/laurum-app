import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/date_group_header.dart';
import 'package:widgetbook/widgetbook.dart';

final dateGroupHeaderUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const SingleChildScrollView(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        DateGroupHeader(label: 'Date'),
        DateGroupHeader(label: 'Date', summary: 'Summary', summaryColor: AppColors.errorInk),
      ],
    ),
  ),
);
