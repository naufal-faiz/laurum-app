import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/nominal_chips.dart';
import 'package:widgetbook/widgetbook.dart';

final nominalChipsUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        NominalChips(amounts: const [1000, 2000, 3000], onSelected: (_) {}),
        NominalChips(
          amounts: const [1000, 2000],
          selectedAmount: 2000,
          increment: false,
          onSelected: (_) {},
        ),
        const NominalChips(amounts: [1000]),
      ],
    ),
  ),
);
