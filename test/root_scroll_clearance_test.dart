import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/organisms/bottom_nav_bar.dart';
import 'package:laurum/shared/widgets/organisms/customer_row.dart';
import 'package:laurum/shared/widgets/organisms/order_card.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final route in ['/pelanggan', '/lainnya', '/laporan']) {
    testWidgets('$route scroll bottom keeps final content visible', (tester) async {
      tester.view.physicalSize = const Size(390, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await pumpAntrean(tester, location: route);
      final view = find
          .byWidgetPredicate(
            (widget) => widget is Scrollable && widget.axisDirection == AxisDirection.down,
          )
          .first;
      final state = tester.state<ScrollableState>(view);
      for (var step = 0; step < 8; step++) {
        state.position.jumpTo(state.position.maxScrollExtent);
        await tester.pumpAndSettle();
      }
      if (route == '/laporan') {
        expect(find.byType(BottomNavBar), findsNothing);
        final last = tester.getRect(find.byType(OrderCard).last);
        expect(last.bottom, lessThanOrEqualTo(640));
        expect(last.top, greaterThanOrEqualTo(0));
        expect(tester.takeException(), isNull);
        return;
      }
      final circle = tester.getRect(
        find.descendant(
          of: find.byType(BottomNavBar),
          matching: find.byType(InkWell),
        ),
      );
      if (route == '/pelanggan') {
        expect(tester.getRect(find.byType(CustomerRow).last).bottom, lessThan(circle.top));
      } else {
        expect(
          tester.getRect(find.widgetWithText(AppButton, 'Keluar')).bottom,
          lessThan(circle.top),
        );
      }
    });
  }
}
