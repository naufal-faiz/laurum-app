import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/customers/widgets/customer_detail_actions_section.dart';
import 'package:laurum/features/customers/widgets/customer_statistics_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_sub.dart';
import 'package:laurum/shared/widgets/molecules/stat_tile.dart';

import 'customer_detail_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final width in [280.0, 320.0, 390.0, 600.0]) {
    for (final scale in [0.85, 1.0, 1.3, 2.0]) {
      testWidgets('detail unscaled viewport$width text$scale remains usable', (tester) async {
        await pumpUnscaledCustomerDetail(tester, width: width, scale: scale);
        expect(tester.takeException(), isNull);
        final headerTop = tester.getTopLeft(find.byType(AppBarSub));
        final contact = find.widgetWithText(AppButton, 'Buka WhatsApp');
        await tester.ensureVisible(contact);
        expect(tester.widget<AppButton>(contact).onPressed, isNotNull);
        await tester.scrollUntilVisible(find.text('Setor tabungan'), 300);
        expect(tester.getTopLeft(find.byType(AppBarSub)), headerTop);
        await tester.scrollUntilVisible(find.text('Riwayat order terakhir'), 400);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
  testWidgets('statistics form two columns at reference width; actions share a row', (
    tester,
  ) async {
    await pumpUnscaledCustomerDetail(tester);
    final stats = find.descendant(
      of: find.byType(CustomerStatisticsSection),
      matching: find.byType(StatTile),
    );
    expect(tester.getTopLeft(stats.at(0)).dy, tester.getTopLeft(stats.at(1)).dy);
    expect(tester.getSize(stats.at(0)).height, tester.getSize(stats.at(1)).height);
    expect(tester.getTopLeft(stats.at(2)).dy, greaterThan(tester.getTopLeft(stats.at(0)).dy));
    final actions = find.byType(CustomerDetailActionsSection).first;
    final buttons = find.descendant(of: actions, matching: find.byType(AppButton));
    expect(tester.getTopLeft(buttons.at(0)).dy, tester.getTopLeft(buttons.at(1)).dy);
  });
  testWidgets('large text stacks statistics and action pairs instead of clipping', (tester) async {
    await pumpUnscaledCustomerDetail(tester, width: 320, scale: 2);
    final stats = find.descendant(
      of: find.byType(CustomerStatisticsSection),
      matching: find.byType(StatTile),
    );
    await tester.scrollUntilVisible(stats.first, 300);
    expect(tester.getTopLeft(stats.at(1)).dy, greaterThan(tester.getTopLeft(stats.at(0)).dy));
    final actions = find.byType(CustomerDetailActionsSection).first;
    final buttons = find.descendant(of: actions, matching: find.byType(AppButton));
    expect(tester.getTopLeft(buttons.at(1)).dy, greaterThan(tester.getTopLeft(buttons.at(0)).dy));
    expect(tester.takeException(), isNull);
  });
}
