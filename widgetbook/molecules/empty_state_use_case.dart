import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:widgetbook/widgetbook.dart';

final emptyStateUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        const EmptyState(title: 'Empty', icon: AppIcons.queue),
        EmptyState(
          title: 'No results',
          icon: AppIcons.search,
          description: 'Try another filter',
          actionLabel: 'Reset',
          onAction: () {},
        ),
      ],
    ),
  ),
);
