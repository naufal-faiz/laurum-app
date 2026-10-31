import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/report_totals.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/reports/state/report_custom_range.dart';
import 'package:laurum/features/reports/state/report_period.dart';
import 'package:laurum/features/reports/state/report_view.dart';
import 'package:laurum/features/reports/widgets/report_body_section.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/organisms/report_summary.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('ReportBodySection delegates debt action and hides balances on empty custom dates', (
    tester,
  ) async {
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(scope.dispose);
    final day = DateTime(2026, 10, 16);
    scope.read(reportCustomRangeProvider.notifier).select(day, day, now: day);
    scope.read(reportPeriodProvider.notifier).select(3);
    final view = await scope.read(reportViewProvider.future);
    var opens = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ReportBodySection(data: view, onOutstanding: () => opens++),
        ),
      ),
    );
    final debt = find.textContaining('Piutang aktif');
    await tester.ensureVisible(debt);
    await tester.tap(debt);
    expect(opens, 1);
    final empty = ReportView(
      period: 3,
      range: ReportRange(DateTime(2026), DateTime(2026, 1, 2)),
      totals: const ReportTotals(activeOutstanding: 400500, savingsBalance: 430000),
      unpaidCount: 5,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ReportBodySection(data: empty, onOutstanding: () => opens++),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Belum ada data periode ini'), findsOneWidget);
    expect(find.byType(ReportSummary), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
