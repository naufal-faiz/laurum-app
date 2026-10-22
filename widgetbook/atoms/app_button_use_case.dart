import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:widgetbook/widgetbook.dart';

final appButtonUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.cardGap,
      children: [
        for (final variant in AppButtonVariant.values)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.cardGap),
            child: AppButton(
              variant.name,
              variant: variant,
              icon: AppIcons.check,
              onPressed: () {},
            ),
          ),
        const AppButton('Disabled', icon: AppIcons.check),
      ],
    ),
  ),
);
