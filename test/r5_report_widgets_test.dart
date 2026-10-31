import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/export_service.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/reports/state/report_custom_range.dart';
import 'package:laurum/features/reports/state/report_period.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/molecules/footer_bar.dart';
import 'package:laurum/shared/widgets/molecules/period_tabs.dart';
import 'package:laurum/shared/widgets/organisms/report_summary.dart';
import 'package:laurum/shared/widgets/organisms/weekly_bar_chart.dart';

import 'antrean_test_host.dart';

class HeldReportExport extends FakeExportService {
  final gate = Completer<void>();
  @override
  Future<String> exportReport({required String fileName, required String content}) async {
    await gate.future;
    return super.exportReport(fileName: fileName, content: content);
  }
}

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('header exports active range and disables actions until completion', (tester) async {
    final service = HeldReportExport();
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        exportServiceProvider.overrideWithValue(service),
      ],
    );
    final day = DateTime(2026, 10, 16);
    scope.read(reportCustomRangeProvider.notifier).select(day, day, now: day);
    scope.read(reportPeriodProvider.notifier).select(3);
    await pumpAntrean(tester, container: scope, location: '/laporan');
    expect(find.byType(FooterBar), findsNothing);
    await tester.tap(find.text('Ekspor Excel'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextButton>(find.widgetWithText(TextButton, 'Ekspor Excel')).onPressed,
      isNull,
    );
    expect(tester.widget<PeriodTabs>(find.byType(PeriodTabs)).onSelected, isNull);
    service.gate.complete();
    await tester.pumpAndSettle();
    final export = service.exportedReports.single;
    expect(export.fileName, 'laporan-20261016-20261016.csv');
    expect(export.content, startsWith('\uFEFF'));
    expect(export.content, contains('"Laporan";"16 Okt"'));
    expect(export.content, contains('"Pendapatan";177000'));
    expect(export.content, contains('"Pengeluaran";145000'));
    expect(export.content, contains('"16 Okt";177000'));
    expect(
      tester.getTopLeft(find.text('Laporan siap diekspor.')).dy,
      lessThan(tester.getTopLeft(find.byType(PeriodTabs)).dy),
    );
  });

  for (final empty in [true, false]) {
    testWidgets('custom empty=$empty handles empty/long range without weekly detail', (
      tester,
    ) async {
      final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
      scope
          .read(reportCustomRangeProvider.notifier)
          .select(
            DateTime(2026, empty ? 1 : 10),
            DateTime(2026, empty ? 1 : 10, empty ? 1 : 16),
            now: DateTime(2026, 10, 16),
          );
      scope.read(reportPeriodProvider.notifier).select(3);
      await pumpAntrean(tester, container: scope, location: '/laporan');
      if (empty) {
        expect(find.text('Belum ada data periode ini'), findsOneWidget);
        expect(find.byType(ReportSummary), findsNothing);
        expect(
          tester.widget<TextButton>(find.widgetWithText(TextButton, 'Ekspor Excel')).onPressed,
          isNull,
        );
      } else {
        final vertical = find.byWidgetPredicate(
          (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
        );
        await tester.scrollUntilVisible(
          find.text('Grafik harian ditampilkan untuk rentang hingga 7 hari.'),
          300,
          scrollable: vertical,
        );
        expect(find.byType(WeeklyBarChart), findsNothing);
      }
      expect(tester.takeException(), isNull);
    });
  }
}
