import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:widgetbook/widgetbook.dart';

final sectionHeaderUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        const SectionHeader(title: 'Section'),
        SectionHeader(
          title: 'Section with action',
          subtitle: 'Description',
          actionLabel: 'Action',
          onAction: () {},
        ),
      ],
    ),
  ),
);
