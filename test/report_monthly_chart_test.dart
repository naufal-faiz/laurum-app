import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/reports/state/report_period.dart';
import 'package:laurum/features/reports/state/report_view.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/organisms/weekly_bar_chart.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  test('monthly daily series retains ledger totals and future days stay unknown', () async {
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(scope.dispose);
    scope.read(reportPeriodProvider.notifier).select(2);
    final view = await scope.read(reportViewProvider.future);
    expect(view.daily, hasLength(31));
    expect(view.dayLabels, hasLength(31));
    expect(view.dayLabels.first, '1 Okt');
    expect(view.dayLabels.last, '31 Okt');
    expect(view.daily!.take(16), everyElement(isNotNull));
    expect(view.daily!.skip(16), everyElement(isNull));
    expect(
      view.daily!.whereType<int>().fold(0, (sum, amount) => sum + amount),
      view.totals.revenue,
    );
  });
  for (final count in [1, 7, 31]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('gradient for$count days, actual font$scale, horizontal month reaches last day', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: Scaffold(
              body: MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                child: SizedBox(
                  width: 320,
                  child: WeeklyBarChart(
                    labels: [for (var day = 1; day <= count; day++) 'D$day'],
                    amounts: List.filled(count, 50000),
                  ),
                ),
              ),
            ),
          ),
        );
        final bars = tester
            .widgetList<Container>(find.byType(Container))
            .where(
              (widget) =>
                  widget.decoration is BoxDecoration &&
                  (widget.decoration! as BoxDecoration).gradient != null,
            );
        expect(bars, hasLength(count));
        for (final bar in bars) {
          final gradient = (bar.decoration! as BoxDecoration).gradient! as LinearGradient;
          expect(gradient.colors, [AppColors.primaryTint, AppColors.primary]);
          expect(gradient.begin, Alignment.topCenter);
          expect(gradient.end, Alignment.bottomCenter);
        }
        if (count == 31) {
          await tester.drag(find.byType(SingleChildScrollView), const Offset(-10000, 0));
          await tester.pumpAndSettle();
          expect(tester.getRect(find.text('D31')).right, lessThanOrEqualTo(320));
          expect(tester.getRect(find.text('D31')).left, greaterThanOrEqualTo(0));
        }
        expect(tester.takeException(), isNull);
      });
    }
  }
}
