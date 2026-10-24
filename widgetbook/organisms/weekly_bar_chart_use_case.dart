import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/organisms/weekly_bar_chart.dart';
import 'package:widgetbook/widgetbook.dart';

final weeklyBarChartUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const SingleChildScrollView(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: WeeklyBarChart(
      labels: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'],
      amounts: [340000, 385000, 290000, 410000, 375000, null, null],
      averageLabel: 'Rata-rata Rp360.000/hari',
      peakLabel: 'Puncak: Kamis',
    ),
  ),
);
