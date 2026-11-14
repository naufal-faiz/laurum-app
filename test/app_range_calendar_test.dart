import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_calendar_day.dart';
import 'package:laurum/shared/widgets/organisms/app_range_calendar.dart';

import 'test_fonts.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID');
    await loadTestFonts();
  });
  testWidgets('calendar renders Monday grid, range, bounds and month navigation', (tester) async {
    DateTime? picked, month;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SizedBox(
            width: 350,
            child: AppRangeCalendar(
              month: DateTime(2026),
              firstDate: DateTime(2026, 1, 5),
              lastDate: DateTime(2026, 2, 10),
              start: DateTime(2026, 1, 9),
              end: DateTime(2026, 1, 14),
              onDay: (value) => picked = value,
              onMonth: (value) => month = value,
            ),
          ),
        ),
      ),
    );
    expect(find.text('Januari 2026'), findsOneWidget);
    final days = tester.widgetList<AppCalendarDay>(find.byType(AppCalendarDay)).toList();
    expect(days, hasLength(42));
    expect(days.first.day, DateTime(2025, 12, 29));
    expect(days.first.day.weekday, DateTime.monday);
    expect(days.first.enabled, isFalse);
    expect(days.where((day) => day.selected).map((day) => day.day), [
      DateTime(2026, 1, 9),
      DateTime(2026, 1, 14),
    ]);
    expect(days.where((day) => day.inRange), hasLength(4));
    expect(
      tester.getTopLeft(find.byKey(ValueKey(DateTime(2026, 1, 5)))).dy,
      greaterThan(tester.getTopLeft(find.byKey(ValueKey(DateTime(2025, 12, 29)))).dy),
    );
    await tester.tap(find.byTooltip('Bulan sebelumnya'));
    expect(month, isNull);
    await tester.tap(find.byTooltip('Bulan berikutnya'));
    expect(month, DateTime(2026, 2));
    await tester.tap(find.byKey(ValueKey(DateTime(2026, 1, 12))));
    expect(picked, DateTime(2026, 1, 12));
    expect(tester.takeException(), isNull);
  });
  testWidgets('calendar day exposes selected full date and disabled days reject taps', (
    tester,
  ) async {
    var taps = 0;
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Row(
            children: [
              AppCalendarDay(day: DateTime(2026, 11, 9), selected: true, onPressed: () => taps++),
              AppCalendarDay(day: DateTime(2026, 11, 15), enabled: false, onPressed: () => taps++),
            ],
          ),
        ),
      ),
    );
    expect(find.bySemanticsLabel(RegExp('Senin.*9 Nov 2026')), findsOneWidget);
    final button = tester.widget<TextButton>(find.widgetWithText(TextButton, '9'));
    expect(button.style!.backgroundColor!.resolve({}), AppColors.primary);
    await tester.tap(find.text('9'));
    await tester.tap(find.text('15'));
    expect(taps, 1);
    expect(tester.widget<TextButton>(find.widgetWithText(TextButton, '15')).onPressed, isNull);
    semantics.dispose();
  });
}
