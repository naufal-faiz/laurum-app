import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/reports/widgets/report_header_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_search_field.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_root.dart';
import 'package:laurum/shared/widgets/molecules/stat_tile.dart';
import 'package:laurum/shared/widgets/organisms/report_summary.dart';
import 'package:laurum/shared/widgets/organisms/top_services.dart';

import 'antrean_test_host.dart';
import 'keyboard_test_helper.dart';
import 'report_redesign_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  final vertical = find.byWidgetPredicate(
    (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
  );
  for (final width in [280.0, 320.0, 390.0, 600.0]) {
    for (final scale in [0.85, 1.0, 1.3, 2.0]) {
      testWidgets('report viewport$width actual font$scale keeps header and all content usable', (
        tester,
      ) async {
        await pumpReportUnscaled(tester, width: width, scale: scale);
        expect(tester.takeException(), isNull);
        final header = tester.getTopLeft(find.byType(ReportHeaderSection));
        expect(tester.widget<ReportSummary>(find.byType(ReportSummary)).totals.revenue, 589000);
        await tester.scrollUntilVisible(find.byType(TopServices), 400, scrollable: vertical);
        await tester.scrollUntilVisible(find.byType(AppSearchField), 500, scrollable: vertical);
        expect(tester.getTopLeft(find.byType(ReportHeaderSection)), header);
        expect(
          tester
              .widget<AppButton>(
                find.ancestor(of: find.textContaining('Excel'), matching: find.byType(AppButton)),
              )
              .onPressed,
          isNotNull,
        );
        expect(tester.takeException(), isNull);
      });
    }
  }
  testWidgets('root report uses one header and preserves navigation', (tester) async {
    await pumpAntrean(tester, location: '/laporan');
    expect(find.byType(AppBarRoot), findsNothing);
    expect(find.text('Laporan'), findsOneWidget);
    expect(find.text('Ringkasan usaha · Minggu ini'), findsOneWidget);
    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    expect(find.text('Lainnya'), findsWidgets);
  });
  testWidgets('full profit amount stays on one line at actual2x font', (tester) async {
    await pumpReportUnscaled(tester, width: 280, scale: 2);
    final paragraph = tester.renderObject<RenderParagraph>(find.text('-Rp261.000'));
    final boxes = paragraph.getBoxesForSelection(
      const TextSelection(baseOffset: 0, extentOffset: '-Rp261.000'.length),
    );
    expect(boxes.map((box) => box.top).toSet(), hasLength(1));
    expect(tester.takeException(), isNull);
  });
  testWidgets('cash and debt use equal columns at390 and stack with larger font', (tester) async {
    await pumpReportUnscaled(tester);
    final cash = find.widgetWithText(StatTile, 'Kas masuk');
    final debt = find.widgetWithText(StatTile, 'Piutang aktif');
    expect(tester.getTopLeft(cash).dy, tester.getTopLeft(debt).dy);
    expect(tester.getSize(cash).height, tester.getSize(debt).height);
  });
  testWidgets('report search remains above keyboard300dp with direct2x font', (tester) async {
    await pumpReportUnscaled(tester, width: 320, scale: 2);
    await tester.scrollUntilVisible(find.byType(AppSearchField), 500, scrollable: vertical);
    await expectKeyboardVisible(tester, field: find.byType(AppSearchField));
    expect(tester.takeException(), isNull);
  });
}
