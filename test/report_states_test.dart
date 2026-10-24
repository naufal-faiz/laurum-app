import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/report_totals.dart';
import 'package:laurum/features/reports/data/report_fixtures.dart';
import 'package:laurum/features/reports/pages/report_view.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  final empty = ReportView(
    period: 1,
    range: weekRange,
    totals: const ReportTotals(),
    unpaidCount: 0,
  );
  testWidgets('loading resolves to empty report and export remains disabled', (tester) async {
    final pending = Completer<ReportView>();
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        reportViewProvider.overrideWith((ref) => pending.future),
      ],
    );
    await pumpAntrean(tester, container: scope, location: '/laporan', settle: false);
    await tester.pump();
    expect(find.byType(AppSkeleton), findsWidgets);
    pending.complete(empty);
    await tester.pumpAndSettle();
    expect(find.text('Belum ada data periode ini'), findsOneWidget);
    expect(
      tester.widget<AppButton>(find.widgetWithText(AppButton, 'Ekspor ke Excel')).onPressed,
      isNull,
    );
  });
  testWidgets('load failure offers retry and recovers', (tester) async {
    var calls = 0;
    final scope = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        ...dummyRepositoryOverrides,
        reportViewProvider.overrideWith((ref) async {
          if (calls++ == 0) throw StateError('test');
          return empty;
        }),
      ],
    );
    await pumpAntrean(tester, container: scope, location: '/laporan');
    expect(find.text('Gagal memuat laporan'), findsOneWidget);
    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();
    expect(calls, 2);
    expect(find.text('Belum ada data periode ini'), findsOneWidget);
  });
}
