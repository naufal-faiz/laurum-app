import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/organisms/numpad.dart';
import 'package:widgetbook/widgetbook.dart';

final numpadUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      spacing: AppSpacing.cardGap,
      children: [
        Numpad(
          onKey: (_) {},
          amounts: const [5000, 10000, 20000],
          selectedAmount: 10000,
          onNominalSelected: (_) {},
        ),
        Numpad(variant: NumpadVariant.decimal, onKey: (_) {}),
      ],
    ),
  ),
);
