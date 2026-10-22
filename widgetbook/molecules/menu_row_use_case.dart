import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:widgetbook/widgetbook.dart';

final menuRowUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        MenuRow(label: 'Menu', icon: AppIcons.service, onTap: () {}),
        MenuRow(
          label: 'With subtitle',
          subtitle: 'Description',
          icon: AppIcons.printer,
          onTap: () {},
        ),
        const MenuRow(label: 'Disabled', icon: AppIcons.lock),
      ],
    ),
  ),
);
