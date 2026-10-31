import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/state/order_detail_controller.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/reports/state/report_custom_range.dart';
import 'package:laurum/features/reports/state/report_period.dart';
import 'package:laurum/features/reports/state/report_view.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  late ProviderContainer scope;
  setUp(() => scope = ProviderContainer(overrides: dummyRepositoryOverrides));
  tearDown(() => scope.dispose());
  void select(DateTime start, DateTime end) {
    scope.read(reportCustomRangeProvider.notifier).select(start, end, now: DateTime(2026, 10, 16));
    scope.read(reportPeriodProvider.notifier).select(3);
  }

  test('same day uses actual six notes, payments and expenses, never today baseline', () async {
    select(DateTime(2026, 10, 16), DateTime(2026, 10, 16));
    final view = await scope.read(reportViewProvider.future);
    expect(view.totals.transactionCount, 6);
    expect(view.totals.revenue, 177000);
    expect(view.totals.cashIn, 130500);
    expect(view.totals.expenses, 145000);
    expect(view.totals.profit, 32000);
    expect(view.daily, [177000]);
    expect(view.services!.fold(0, (sum, s) => sum + s.revenue), 177000);
  });
  test('partial fixture week reconciles dates and expenses without weekly borrowing', () async {
    select(DateTime(2026, 10, 14), DateTime(2026, 10, 15));
    final view = await scope.read(reportViewProvider.future);
    expect(view.totals.transactionCount, 8);
    expect(view.totals.revenue, 412000);
    expect(view.totals.expenses, 85000);
    expect(view.totals.cashIn, 258000);
    expect(view.daily, [248000, 164000]);
  });
  test('empty period does not invent flows; long custom period hides daily chart', () async {
    select(DateTime(2026), DateTime(2026));
    final empty = await scope.read(reportViewProvider.future);
    expect(empty.isEmpty, isTrue);
    expect(empty.totals.revenue, 0);
    expect(empty.totals.expenses, 0);
    expect(empty.services, isEmpty);
    select(DateTime(2026, 10), DateTime(2026, 10, 16));
    expect((await scope.read(reportViewProvider.future)).daily, isNull);
  });
  test('cancel note and delete expense reactively rebuild custom report and services', () async {
    select(DateTime(2026, 10, 16), DateTime(2026, 10, 16));
    await scope.read(reportViewProvider.future);
    final detail = (await scope.read(orderDetailProvider('ord-0142').future))!;
    expect(await scope.read(orderActionsProvider.notifier).cancel(detail), isTrue);
    await scope.read(expenseRepositoryProvider).deleteExpense('exp-018');
    final view = await scope.read(reportViewProvider.future);
    expect(view.totals.revenue, 145500);
    expect(view.totals.expenses, 35000);
    expect(view.totals.transactionCount, 5);
    expect(view.daily, [145500]);
    expect(view.services!.fold(0, (sum, s) => sum + s.revenue), 145500);
  });
}
