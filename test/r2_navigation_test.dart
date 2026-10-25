import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/shell/pages/placeholder_routes.dart';
import 'package:laurum/shared/widgets/organisms/bottom_nav_bar.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final (index, path) in tabRoutes.keys.indexed) {
    testWidgets('Transaksi pushes from $path and returns to the same tab', (tester) async {
      final host = await pumpAntrean(tester, location: path);
      expect(tabRoutes, hasLength(4));
      expect(tabRoutes.containsKey('/transaksi'), isFalse);
      expect(find.byType(FloatingActionButton), findsNothing);
      final nav = find.byType(BottomNavBar);
      expect(tester.widget<BottomNavBar>(nav).activeIndex, index);
      await tester.tap(find.descendant(of: nav, matching: find.text('Transaksi')));
      await tester.pumpAndSettle();
      expect(find.text('Buat transaksi'), findsOneWidget);
      expect(find.byType(BottomNavBar), findsNothing);
      expect(host.router.canPop(), isTrue);
      host.router.pop();
      await tester.pumpAndSettle();
      expect(host.router.routeInformationProvider.value.uri.path, path);
      expect(tester.widget<BottomNavBar>(nav).activeIndex, index);
    });
    testWidgets('Piutang navigates to $path and supports create', (tester) async {
      final host = await pumpAntrean(tester, location: '/laporan/piutang');
      final nav = find.byType(BottomNavBar);
      expect(tester.widget<BottomNavBar>(nav).activeIndex, 2);
      await tester.tap(find.descendant(of: nav, matching: find.text('Transaksi')));
      await tester.pumpAndSettle();
      expect(host.router.canPop(), isTrue);
      host.router.pop();
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: nav,
          matching: find.text(['Antrean', 'Pelanggan', 'Laporan', 'Lainnya'][index]),
        ),
      );
      await tester.pumpAndSettle();
      expect(host.router.routeInformationProvider.value.uri.path, path);
      expect(tester.widget<BottomNavBar>(nav).activeIndex, index);
    });
  }
  testWidgets('Account opens Lainnya', (tester) async {
    final host = await pumpAntrean(tester);
    await tester.tap(find.byTooltip('Usaha dan akun'));
    await tester.pumpAndSettle();
    expect(host.router.routeInformationProvider.value.uri.path, '/lainnya');
    expect(tester.widget<BottomNavBar>(find.byType(BottomNavBar)).activeIndex, 3);
  });
}
