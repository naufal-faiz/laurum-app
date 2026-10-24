import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/reports/data/report_fixtures.dart';
import 'package:laurum/shared/widgets/organisms/report_summary.dart';

import '../widgetbook/organisms/report_summary_use_case.dart';
import 'organism_gallery.dart';

void main() {
  testWidgets('ReportSummary shows weekly totals and opens outstanding', (tester) async {
    var opened = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: ReportSummary(
              totals: weekBaseline.totals,
              expenseSummary: 'Deterjen & operasional',
              unpaidCount: 5,
              onOutstandingTap: () => opened++,
            ),
          ),
        ),
      ),
    );
    expect(find.text('Rp950.000'), findsOneWidget);
    expect(find.textContaining('Rp1.800.000'), findsOneWidget);
    expect(find.textContaining('Rp400.500'), findsOneWidget);
    expect(find.textContaining('5 nota belum lunas'), findsOneWidget);
    await tester.tap(find.textContaining('Piutang aktif'));
    expect(opened, 1);
  });
  registerOrganismGallery('report_summary', reportSummaryUseCase.builder, height: 800);
}
