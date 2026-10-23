import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/locked_row.dart';
import 'package:widgetbook/widgetbook.dart';

final lockedRowUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const SingleChildScrollView(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        LockedRow(label: 'Locked row', lockLabel: 'Always visible'),
        LockedRow(
          label: 'With detail',
          lockLabel: 'Locked',
          description: 'Description',
          icon: AppIcons.receipt,
        ),
      ],
    ),
  ),
);
