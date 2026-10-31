import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/reports/state/report_custom_range.dart';
import 'package:laurum/features/reports/state/report_period.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/molecules/period_tabs.dart';
import 'package:laurum/shared/widgets/organisms/top_services.dart';
import 'package:laurum/shared/widgets/organisms/weekly_bar_chart.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final width in [390, 320]) {
    testWidgets('custom report $width layout and localized picker', (tester) async {
      tester.view.physicalSize = Size(width.toDouble(), 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
      final day = DateTime(2026, 10, 16);
      final start = DateTime(2026, 10, width == 320 ? 10 : 14);
      scope.read(reportCustomRangeProvider.notifier).select(start, day, now: day);
      scope.read(reportPeriodProvider.notifier).select(3);
      await (FontLoader(
        'MaterialIcons',
      )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
      await pumpAntrean(
        tester,
        container: scope,
        location: '/laporan',
        textScale: width == 320 ? 2 : 1,
      );
      if (width == 390) {
        await expectLater(
          find.byKey(const ValueKey('antrean-golden')),
          matchesGoldenFile('goldens/r5_report_custom.png'),
        );
      }
      final vertical = find.byWidgetPredicate(
        (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
      );
      await tester.scrollUntilVisible(find.byType(WeeklyBarChart), 300, scrollable: vertical);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.byType(TopServices), 300, scrollable: vertical);
      await tester.pumpAndSettle();
      final dateTab = find.descendant(
        of: find.byType(PeriodTabs),
        matching: find.text(width == 320 ? '10-16 Okt' : '14-16 Okt'),
      );
      await tester.ensureVisible(dateTab);
      await tester.tap(dateTab);
      await tester.pumpAndSettle();
      expect(find.byType(DateRangePickerDialog), findsOneWidget);
      if (width == 390) {
        await expectLater(
          find.byKey(const ValueKey('antrean-golden')),
          matchesGoldenFile('goldens/r5_date_picker.png'),
        );
      }
      final loc = MaterialLocalizations.of(tester.element(find.byType(DateRangePickerDialog)));
      await tester.tap(find.byTooltip(loc.closeButtonTooltip));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
