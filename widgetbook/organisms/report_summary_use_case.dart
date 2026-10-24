import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/reports/data/report_fixtures.dart';
import 'package:laurum/shared/widgets/organisms/report_summary.dart';
import 'package:widgetbook/widgetbook.dart';

final reportSummaryUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: ReportSummary(
      totals: weekBaseline.totals,
      expenseSummary: 'Deterjen & operasional',
      unpaidCount: 5,
      onOutstandingTap: () {},
    ),
  ),
);
