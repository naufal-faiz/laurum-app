import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/export_service.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/shared/widgets/molecules/period_tabs.dart';
import 'package:laurum/shared/widgets/organisms/report_summary.dart';
import 'package:laurum/shared/widgets/organisms/top_services.dart';
import 'package:laurum/shared/widgets/organisms/weekly_bar_chart.dart';

import 'antrean_test_host.dart';

void main() {
  final vertical = find.byWidgetPredicate(
    (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
  );
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('weekly report shows master values, exports and switches periods', (tester) async {
    final host = await pumpAntrean(tester, location: '/laporan');
    final summary = tester.widget<ReportSummary>(find.byType(ReportSummary));
    expect(summary.totals.revenue, 1800000);
    expect(find.text('Rp950.000'), findsOneWidget);
    expect(summary.totals.expenses, 850000);
    await tester.scrollUntilVisible(find.byType(WeeklyBarChart), 300, scrollable: vertical);
    await tester.pumpAndSettle();
    expect(find.text('Rata-rata Rp360.000/hari'), findsOneWidget);
    expect(find.text('Puncak: Kamis'), findsOneWidget);
    await tester.scrollUntilVisible(find.byType(TopServices), 300, scrollable: vertical);
    await tester.pumpAndSettle();
    expect(find.text('Rp882.000'), findsOneWidget);
    await tester.tap(find.text('Ekspor Excel'));
    await tester.pumpAndSettle();
    expect(find.text('Laporan siap diekspor.'), findsOneWidget);
    final export = host.container.read(exportServiceProvider) as FakeExportService;
    expect(export.exportedReports.single.fileName, 'laporan-1.csv');
    expect(export.exportedReports.single.content, contains('"Pendapatan";1800000'));
    await tester.tap(find.descendant(of: find.byType(PeriodTabs), matching: find.text('Hari ini')));
    await tester.pumpAndSettle();
    expect(find.text('Rp230.000'), findsOneWidget);
    expect(find.byType(TopServices), findsNothing);
    await tester.tap(
      find.descendant(of: find.byType(PeriodTabs), matching: find.text('Bulan ini')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Rp2.400.000'), findsOneWidget);
    expect(find.byType(WeeklyBarChart), findsNothing);
    await tester.scrollUntilVisible(
      find.textContaining('Piutang aktif Rp400.500'),
      200,
      scrollable: vertical,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Piutang aktif Rp400.500'));
    await tester.pumpAndSettle();
    expect(find.text('Daftar piutang'), findsWidgets);
  });

  testWidgets('320px with 2x text can scroll all report sections without overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpAntrean(tester, location: '/laporan', textScale: 2);
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.byType(TopServices), 350, scrollable: vertical);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
