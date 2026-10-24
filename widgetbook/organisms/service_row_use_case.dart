import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/shared/widgets/organisms/service_row.dart';
import 'package:widgetbook/widgetbook.dart';

final serviceRowUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      spacing: AppSpacing.cardGap,
      children: [
        for (final service in serviceFixtures)
          ServiceRow(
            name: service.name,
            kind: service.kind,
            price: service.price,
            durationDays: service.durationDays,
            isActive: service.isActive,
            onTap: () {},
            onActiveChanged: (_) {},
          ),
        ServiceRow(
          name: serviceFixtures.first.name,
          kind: serviceFixtures.first.kind,
          price: serviceFixtures.first.price,
          durationDays: serviceFixtures.first.durationDays,
          showSwitch: false,
        ),
      ],
    ),
  ),
);
