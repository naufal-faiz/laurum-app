import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/features/orders/state/order_detail_controller.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/reports/state/report_custom_range.dart';
import 'package:laurum/features/reports/state/report_orders_data.dart';
import 'package:laurum/features/reports/state/report_period.dart';
import 'package:laurum/features/reports/state/report_view.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/atoms/app_search_field.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';

import 'antrean_test_host.dart';

final _week = ReportRange(DateTime(2026, 10, 12), DateTime(2026, 10, 19));
final _day = ReportRange(DateTime(2026, 10, 16), DateTime(2026, 10, 17));

void main() {
  final vertical = find.byWidgetPredicate(
    (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
  );
  setUpAll(() => initializeDateFormatting('id_ID'));

  test('report orders filter by active range, search, status and newest first', () async {
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(scope.dispose);
    final data = await scope.read(reportOrdersProvider.future);
    final week = filterReportOrders(data, filter: 0, search: '', range: _week);
    expect(week, hasLength(14));
    expect(week.fold(0, (sum, order) => sum + order.total), 589000);
    expect(week.first.orderNo, 'A-0142');
    expect(
      filterReportOrders(data, filter: 0, search: 'rina', range: _week).single.orderNo,
      'A-0141',
    );
    expect(
      filterReportOrders(data, filter: 2, search: '', range: _week).map((o) => o.orderNo),
      ['A-0138', 'A-0136'],
    );
    final day = filterReportOrders(data, filter: 0, search: '', range: _day);
    expect(day, hasLength(6));
    expect(day.fold(0, (sum, order) => sum + order.total), 177000);
  });

  test('custom range summary revenue equals the visible notes', () async {
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(scope.dispose);
    final day = DateTime(2026, 10, 16);
    scope.read(reportCustomRangeProvider.notifier).select(day, day, now: day);
    scope.read(reportPeriodProvider.notifier).select(3);
    final view = await scope.read(reportViewProvider.future);
    final data = await scope.read(reportOrdersProvider.future);
    final notes = filterReportOrders(data, filter: 0, search: '', range: view.range);
    expect(view.totals.transactionCount, notes.length);
    expect(view.totals.revenue, notes.fold(0, (sum, order) => sum + order.total));
    expect(view.totals.revenue, 177000);
  });

  testWidgets('report lists notes, filters, searches and opens detail', (tester) async {
    final host = await pumpAntrean(tester, location: '/laporan');
    await tester.scrollUntilVisible(find.byType(AppSearchField), 400, scrollable: vertical);
    expect(find.text('Nota (14)'), findsOneWidget);
    expect(find.text('A-0142'), findsOneWidget);
    expect(find.text('A-0141'), findsOneWidget);
    expect(find.text('Cuci kiloan 4,5 kg'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Rina');
    await tester.pumpAndSettle();
    expect(find.text('A-0141'), findsOneWidget);
    expect(find.text('A-0142'), findsNothing);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: find.byType(ChipBar), matching: find.text('Selesai')));
    await tester.pumpAndSettle();
    expect(find.text('A-0138'), findsOneWidget);
    expect(find.text('A-0142'), findsNothing);
    expect(find.text('Kamis, 15 Okt 2026'), findsOneWidget);

    await tester.ensureVisible(find.text('A-0138'));
    await tester.tap(find.text('A-0138'));
    await tester.pumpAndSettle();
    expect(host.router.canPop(), isTrue);
    expect(find.text('Detail order'), findsOneWidget);
  });

  testWidgets('empty filter shows a hint and cancelling updates the report list', (tester) async {
    final host = await pumpAntrean(tester, location: '/laporan');
    await tester.scrollUntilVisible(
      find.descendant(of: find.byType(ChipBar), matching: find.text('Dibatalkan')),
      400,
      scrollable: vertical,
    );
    await tester.tap(find.descendant(of: find.byType(ChipBar), matching: find.text('Dibatalkan')));
    await tester.pumpAndSettle();
    expect(find.text('Nota tidak ditemukan'), findsOneWidget);
    expect(find.text('Coba kata kunci atau filter lain.'), findsOneWidget);

    final detail = (await host.container.read(orderDetailProvider('ord-0142').future))!;
    expect(await host.container.read(orderActionsProvider.notifier).cancel(detail), isTrue);
    await tester.pumpAndSettle();
    expect(find.text('A-0142'), findsOneWidget);
    expect(find.text('Dibatalkan'), findsWidgets);
  });
}
