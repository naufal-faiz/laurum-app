import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/shared/widgets/atoms/app_search_field.dart';
import 'package:laurum/shared/widgets/organisms/top_services.dart';
import 'package:laurum/shared/widgets/organisms/weekly_bar_chart.dart';

import 'report_redesign_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final scale in [1.0, 2.0]) {
    testWidgets('monthly at320 font$scale keeps amounts, services and orders without chart', (
      tester,
    ) async {
      await pumpReportUnscaled(tester, width: 320, scale: scale, period: 2);
      expect(find.text('Masuk Rp864.000'), findsOneWidget);
      expect(find.text('Keluar Rp1.850.000'), findsOneWidget);
      expect(find.text('-Rp986.000'), findsOneWidget);
      expect(find.byType(WeeklyBarChart), findsNothing);
      expect(find.text('Grafik harian ditampilkan untuk rentang hingga 7 hari.'), findsNothing);
      await expectLater(
        find.byKey(const ValueKey('report-unscaled-golden')),
        matchesGoldenFile('goldens/report_monthly_${scale.toInt()}x.png'),
      );
      final vertical = find.byWidgetPredicate(
        (widget) => widget is Scrollable && widget.axisDirection == AxisDirection.down,
      );
      await tester.scrollUntilVisible(find.byType(TopServices), 300, scrollable: vertical);
      expect(
        tester
            .widget<TopServices>(find.byType(TopServices))
            .services
            .fold<int>(0, (sum, service) => sum + service.revenue),
        864000,
      );
      await tester.scrollUntilVisible(find.byType(AppSearchField), 300, scrollable: vertical);
      expect(find.byType(AppSearchField), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
