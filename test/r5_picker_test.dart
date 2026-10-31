import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/reports/state/report_custom_range.dart';
import 'package:laurum/features/reports/state/report_period.dart';
import 'package:laurum/shared/widgets/molecules/period_tabs.dart';
import 'package:laurum/shared/widgets/organisms/report_summary.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final singleDay in [true, false]) {
    testWidgets(
      'Indonesian picker selects singleDay=$singleDay and cancellation preserves period',
      (tester) async {
        final host = await pumpAntrean(tester, location: '/laporan');
        await tester.ensureVisible(find.text('Pilih tanggal'));
        await tester.tap(find.text('Pilih tanggal'));
        await tester.pumpAndSettle();
        final picker = tester.widget<DateRangePickerDialog>(find.byType(DateRangePickerDialog));
        expect(picker.firstDate, DateTime(2026));
        expect(picker.lastDate, DateTime(2026, 10, 16));
        expect(picker.initialEntryMode, DatePickerEntryMode.calendarOnly);
        final locale = Localizations.localeOf(tester.element(find.byType(DateRangePickerDialog)));
        expect(locale.languageCode, 'id');
        expect(find.byType(TextField), findsNothing);
        await tester.tap(find.text(singleDay ? '16' : '14').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text(singleDay ? '16' : '15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Terapkan'));
        await tester.pumpAndSettle();
        expect(host.container.read(reportPeriodProvider), 3);
        final tabs = tester.widget<PeriodTabs>(find.byType(PeriodTabs));
        expect(tabs.selectedIndex, 3);
        expect(tabs.labels.last, singleDay ? '16 Okt' : '14-15 Okt');
        final summary = tester.widget<ReportSummary>(find.byType(ReportSummary));
        expect(summary.totals.revenue, singleDay ? 177000 : 412000);
        expect(summary.totals.expenses, singleDay ? 145000 : 85000);
        final before = host.container.read(reportCustomRangeProvider);
        await tester.tap(
          find.descendant(of: find.byType(PeriodTabs), matching: find.text(tabs.labels.last)),
        );
        await tester.pumpAndSettle();
        final localizations = MaterialLocalizations.of(
          tester.element(find.byType(DateRangePickerDialog)),
        );
        await tester.tap(find.byTooltip(localizations.closeButtonTooltip));
        await tester.pumpAndSettle();
        expect(host.container.read(reportPeriodProvider), 3);
        expect(host.container.read(reportCustomRangeProvider), before);
        await tester.tap(find.text('Hari ini'));
        await tester.pumpAndSettle();
        await tester.tap(
          find.descendant(of: find.byType(PeriodTabs), matching: find.text(tabs.labels.last)),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip(localizations.closeButtonTooltip));
        await tester.pumpAndSettle();
        expect(host.container.read(reportPeriodProvider), 0);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
