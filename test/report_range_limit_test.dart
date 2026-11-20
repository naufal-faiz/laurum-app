import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/reports/pages/report_range_sheet.dart';
import 'package:laurum/features/reports/state/report_range_controller.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final (start, end, allowed) in [
    (DateTime(2026, 11), DateTime(2026, 11, 14), true),
    (DateTime(2026, 11), DateTime(2026, 11, 15), false),
    (DateTime(2026, 10, 28), DateTime(2026, 11, 10), true),
    (DateTime(2026, 10, 28), DateTime(2026, 11, 11), false),
  ]) {
    testWidgets('range $start to $end apply allowed=$allowed', (tester) async {
      final scope = ProviderContainer();
      addTearDown(scope.dispose);
      scope
          .read(reportRangeDraftProvider.notifier)
          .begin(
            firstDate: DateTime(2026),
            lastDate: DateTime(2026, 12, 31),
            start: start,
            end: end,
          );
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: scope,
          child: MaterialApp(
            theme: AppTheme.light,
            home: const Scaffold(body: ReportRangeSheet()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final apply = tester.widget<AppButton>(find.widgetWithText(AppButton, 'Terapkan'));
      expect(apply.onPressed != null, allowed);
      expect(
        find.text('Rentang maksimal 14 hari, termasuk tanggal awal dan akhir.'),
        allowed ? findsNothing : findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
