import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/toggle_row.dart';
import 'package:widgetbook/widgetbook.dart';

final toggleRowUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        ToggleRow(label: 'With icon', value: true, icon: AppIcons.location, onChanged: (_) {}),
        for (final enabled in [true, false])
          for (final value in [true, false])
            ToggleRow(
              label: enabled ? 'Enabled' : 'Disabled',
              value: value,
              description: 'Description',
              onChanged: enabled ? (_) {} : null,
            ),
      ],
    ),
  ),
);
