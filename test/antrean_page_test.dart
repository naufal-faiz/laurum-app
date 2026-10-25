import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/orders/state/antrean_controller.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/organisms/bottom_nav_bar.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('queue advances, preserves filter across tabs and opens placeholders', (
    tester,
  ) async {
    final host = await pumpAntrean(tester);
    expect(find.text('Berkah Laundry'), findsOneWidget);
    expect(find.text('Semua 12'), findsOneWidget);
    expect(find.text('12 order aktif'), findsOneWidget);
    expect(tester.widget<ChipBar>(find.byType(ChipBar)).labels.last, 'Perlu dicek 3');
    await tester.tap(find.text('Proses 5'));
    await tester.pumpAndSettle();
    final dedi = find.byKey(const ValueKey('ord-0142'));
    await tester.tap(find.descendant(of: dedi, matching: find.text('Tandai siap')));
    await tester.pumpAndSettle();
    expect(find.text('Proses 4'), findsOneWidget);
    expect(tester.widget<ChipBar>(find.byType(ChipBar)).labels[3], 'Siap 5');
    final nav = find.byType(BottomNavBar);
    await tester.tap(find.descendant(of: nav, matching: find.text('Pelanggan')));
    await tester.pumpAndSettle();
    expect(host.router.routeInformationProvider.value.uri.path, '/pelanggan');
    await tester.tap(find.descendant(of: nav, matching: find.text('Antrean')));
    await tester.pumpAndSettle();
    expect(host.container.read(antreanFilterProvider), 2);
    expect(tester.widget<ChipBar>(find.byType(ChipBar)).selectedIndex, 2);
    await tester.tap(find.descendant(of: nav, matching: find.text('Transaksi')));
    await tester.pumpAndSettle();
    expect(host.router.canPop(), isTrue);
    expect(find.text('Buat transaksi'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
  testWidgets('WhatsApp banner follows fake connection and does not block order data', (
    tester,
  ) async {
    final host = await pumpAntrean(tester);
    const banner = 'WhatsApp terputus. AI berhenti membaca pesan.';
    expect(find.text(banner), findsNothing);
    host.container.read(whatsappConnectionProvider.notifier).setConnected(connected: false);
    await tester.pumpAndSettle();
    expect(find.text(banner), findsOneWidget);
    expect(find.text('Semua 12'), findsOneWidget);
    await tester.tap(find.text('Hubungkan'));
    await tester.pumpAndSettle();
    expect(find.text('Hubungkan WhatsApp'), findsWidgets);
    expect(host.router.canPop(), isTrue);
  });
}
