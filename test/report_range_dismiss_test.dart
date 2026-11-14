import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/reports/pages/report_range_sheet.dart';
import 'package:laurum/features/reports/state/report_custom_range.dart';
import 'package:laurum/features/reports/state/report_period.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final close in ['back', 'barrier']) {
    testWidgets('reset and $close preserve actual report range and seeded reopen', (tester) async {
      final host = await pumpAntrean(tester, location: '/laporan');
      final custom = host.container.read(reportCustomRangeProvider);
      final period = host.container.read(reportPeriodProvider);
      await tester.ensureVisible(find.text('Pilih tanggal'));
      await tester.tap(find.text('Pilih tanggal'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<AppButton>(find.widgetWithText(AppButton, 'Terapkan')).onPressed,
        isNull,
      );
      expect(host.container.read(reportCustomRangeProvider), custom);
      expect(host.container.read(reportPeriodProvider), period);
      if (close == 'back') {
        await tester.binding.handlePopRoute();
      } else {
        await tester.tapAt(const Offset(2, 2));
      }
      await tester.pumpAndSettle();
      expect(find.byType(ReportRangeSheet), findsNothing);
      expect(host.container.read(reportCustomRangeProvider), custom);
      expect(host.container.read(reportPeriodProvider), period);
      await tester.tap(find.text('Pilih tanggal'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<AppButton>(find.widgetWithText(AppButton, 'Terapkan')).onPressed,
        isNotNull,
      );
      await tester.tap(find.byTooltip('Tutup'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
