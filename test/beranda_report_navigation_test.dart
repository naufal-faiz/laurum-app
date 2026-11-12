import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/reports/pages/report_page.dart';
import 'package:laurum/features/reports/state/report_period.dart';
import 'package:laurum/features/reports/state/report_view.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('whole revenue card opens weekly report after a different period', (tester) async {
    final host = await pumpAntrean(tester, location: '/beranda');
    final weekly = await host.container.read(weeklyReportViewProvider.future);
    host.container.read(reportPeriodProvider.notifier).select(2);
    await tester.pumpAndSettle();
    final monthly = await host.container.read(reportViewProvider.future);
    expect(monthly.period, 2);
    expect(identical(await host.container.read(weeklyReportViewProvider.future), weekly), isTrue);
    expect(weekly.period, 1);
    final card = find.ancestor(
      of: find.text('Pendapatan minggu ini'),
      matching: find.byType(AppCard),
    );
    await tester.ensureVisible(card);
    await tester.tapAt(tester.getTopLeft(card) + const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(find.byType(ReportPage), findsOneWidget);
    expect(host.container.read(reportPeriodProvider), 1);
    expect(find.text('Minggu ini'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
