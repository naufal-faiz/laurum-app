import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/organisms/bottom_nav_bar.dart';
import 'package:laurum/shared/widgets/organisms/customer_row.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final route in ['/pelanggan', '/lainnya', '/laporan']) {
    testWidgets('$route scroll bottom clears raised transaction circle', (tester) async {
      tester.view.physicalSize = const Size(390, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await pumpAntrean(tester, location: route);
      final view = find.byType(Scrollable).first;
      final state = tester.state<ScrollableState>(view);
      for (var step = 0; step < 8; step++) {
        state.position.jumpTo(state.position.maxScrollExtent);
        await tester.pumpAndSettle();
      }
      final circle = tester.getRect(
        find.descendant(
          of: find.byType(BottomNavBar),
          matching: find.byType(InkWell),
        ),
      );
      if (route == '/pelanggan') {
        expect(tester.getRect(find.byType(CustomerRow).last).bottom, lessThan(circle.top));
      } else if (route == '/lainnya') {
        expect(
          tester.getRect(find.widgetWithText(AppButton, 'Keluar')).bottom,
          lessThan(circle.top),
        );
      } else {
        final list = tester.widget<ListView>(find.byType(ListView).first);
        expect(list.padding!.resolve(TextDirection.ltr).bottom, greaterThan(circle.height / 2));
      }
    });
  }
}
