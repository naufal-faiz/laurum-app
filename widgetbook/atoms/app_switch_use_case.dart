import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_switch.dart';
import 'package:widgetbook/widgetbook.dart';

final appSwitchUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.cardGap,
      children: [
        for (final value in [false, true]) ...[
          AppSwitch(value: value, label: value ? 'On' : 'Off', onChanged: (_) {}),
          AppSwitch(value: value, label: value ? 'On disabled' : 'Off disabled'),
        ],
      ],
    ),
  ),
);
