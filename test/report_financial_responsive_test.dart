import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/report_totals.dart';
import 'package:laurum/core/domain/service_revenue.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/organisms/report_summary.dart';
import 'package:laurum/shared/widgets/organisms/top_services.dart';

import 'test_fonts.dart';

void main() {
  testWidgets('large financial values and long service names remain complete at280dp text2x', (
    tester,
  ) async {
    await loadTestFonts();
    tester.view.physicalSize = const Size(280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var opens = 0;
    const name = 'Layanan laundry dengan nama panjang untuk pengujian tampilan';
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                ReportSummary(
                  totals: const ReportTotals(
                    revenue: 999999999,
                    expenses: 1999999999,
                    transactionCount: 999999,
                    cashIn: 999999999,
                    savingsBalance: 999999999,
                    activeOutstanding: 999999999,
                  ),
                  expenseSummary: 'Operasional dengan catatan yang panjang',
                  unpaidCount: 99999,
                  onOutstandingTap: () => opens++,
                ),
                const TopServices(
                  services: [
                    ServiceRevenue(
                      serviceId: 'test',
                      serviceName: name,
                      unit: 'kg',
                      qtyMilli: 9999999,
                      revenue: 999999999,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    const amount = '-Rp1.000.000.000';
    final paragraph = tester.renderObject<RenderParagraph>(find.text(amount));
    final boxes = paragraph.getBoxesForSelection(
      const TextSelection(baseOffset: 0, extentOffset: amount.length),
    );
    expect(boxes.map((box) => box.top).toSet(), hasLength(1));
    await tester.ensureVisible(find.text('Piutang aktif'));
    await tester.tap(find.text('Piutang aktif'));
    expect(opens, 1);
    await tester.ensureVisible(find.text(name));
    expect(find.text('100% pendapatan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
