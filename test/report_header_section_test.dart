import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/reports/widgets/report_header_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/molecules/period_tabs.dart';

import 'test_fonts.dart';

void main() {
  testWidgets('report header wraps export, delegates callbacks and retains export state', (
    tester,
  ) async {
    await loadTestFonts();
    var backs = 0, exports = 0;
    int? period;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: SizedBox(
              width: 280,
              child: ReportHeaderSection(
                labels: const ['Hari ini', 'Minggu ini', 'Bulan ini', 'Pilih tanggal'],
                selectedIndex: 1,
                message: 'Laporan siap diekspor.',
                onBack: () => backs++,
                onExport: () => exports++,
                onPeriod: (value) => period = value,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byTooltip('Kembali'));
    await tester.tap(find.widgetWithText(AppButton, 'Ekspor Excel'));
    await tester.tap(find.text('Hari ini'));
    expect(backs, 1);
    expect(exports, 1);
    expect(period, 0);
    expect(
      tester.getTopLeft(find.text('Laporan siap diekspor.')).dy,
      lessThan(tester.getTopLeft(find.byType(PeriodTabs)).dy),
    );
    expect(tester.takeException(), isNull);
  });
}
