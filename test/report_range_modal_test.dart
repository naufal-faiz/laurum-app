import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/reports/pages/report_range_sheet.dart';
import 'package:laurum/features/reports/state/report_range_controller.dart';
import 'package:laurum/features/reports/widgets/report_range_summary_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_calendar_day.dart';
import 'package:laurum/shared/widgets/organisms/app_range_calendar.dart';

import 'test_fonts.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID');
    await loadTestFonts();
  });
  for (final width in [280.0, 320.0, 390.0, 600.0]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('date modal viewport$width font$scale reset and apply', (tester) async {
        tester.view.physicalSize = Size(width, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final scope = ProviderContainer();
        addTearDown(scope.dispose);
        scope
            .read(reportRangeDraftProvider.notifier)
            .begin(
              firstDate: DateTime(2026),
              lastDate: DateTime(2026, 11, 14),
              start: DateTime(2026, 11, 9),
              end: DateTime(2026, 11, 14),
            );
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: scope,
            child: MaterialApp(
              theme: AppTheme.light,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
                child: child!,
              ),
              home: const Scaffold(body: ReportRangeSheet()),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(AppRangeCalendar), findsOneWidget);
        expect(find.byType(ReportRangeSummarySection), findsOneWidget);
        expect(find.byType(AppCalendarDay), findsNWidgets(42));
        expect(tester.takeException(), isNull);
        final apply = find.widgetWithText(AppButton, 'Terapkan');
        expect(tester.getBottomRight(apply).dy, lessThan(844));
        if (width == 390) {
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile('goldens/report_range_modal_${scale.toInt()}.png'),
          );
        }
        await tester.tap(find.text('Reset'));
        await tester.pumpAndSettle();
        expect(tester.widget<AppButton>(apply).onPressed, isNull);
        final date = find.byKey(ValueKey(DateTime(2026, 11, 9)));
        await tester.ensureVisible(date);
        await tester.tap(date);
        await tester.pumpAndSettle();
        expect(tester.widget<AppButton>(apply).onPressed, isNull);
        await tester.tap(date);
        await tester.pumpAndSettle();
        expect(tester.widget<AppButton>(apply).onPressed, isNotNull);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
