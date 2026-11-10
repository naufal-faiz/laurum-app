import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/feature_strip.dart';
import 'package:widgetbook/widgetbook.dart';

final featureStripUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const Padding(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: FeatureStrip(
      items: [
        (icon: AppIcons.queue, label: 'Antrean rapi'),
        (icon: AppIcons.receipt, label: 'Struk otomatis'),
        (icon: AppIcons.reports, label: 'Laporan harian'),
      ],
    ),
  ),
);
