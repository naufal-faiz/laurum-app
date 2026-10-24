import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/orders/pages/order_detail_controller.dart';
import 'package:laurum/features/orders/pages/order_detail_data.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  testWidgets('history lists notes, filters, searches and opens detail', (tester) async {
    final host = await pumpAntrean(tester, location: '/transaksi');
    expect(find.text('Hari ini - Jumat, 16 Okt 2026'), findsOneWidget);
    expect(find.text('A-0142'), findsOneWidget);
    expect(find.text('A-0141'), findsOneWidget);
    expect(find.text('Cuci kiloan 4,5 kg'), findsOneWidget);
    expect(find.text('Transaksi baru'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Rina');
    await tester.pumpAndSettle();
    expect(find.text('A-0141'), findsOneWidget);
    expect(find.text('A-0142'), findsNothing);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: find.byType(ChipBar), matching: find.text('Selesai')));
    await tester.pumpAndSettle();
    expect(find.text('A-0138'), findsOneWidget);
    expect(find.text('A-0142'), findsNothing);
    expect(find.text('Kamis, 15 Okt 2026'), findsOneWidget);

    await tester.tap(find.text('A-0138'));
    await tester.pumpAndSettle();
    expect(host.router.canPop(), isTrue);
    expect(find.text('Detail order'), findsOneWidget);
  });

  testWidgets('empty filter shows a hint and the CTA opens a new transaction', (tester) async {
    final host = await pumpAntrean(tester, location: '/transaksi');
    await tester.tap(
      find.descendant(of: find.byType(ChipBar), matching: find.text('Dibatalkan')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Nota tidak ditemukan'), findsOneWidget);
    expect(find.text('Coba kata kunci atau filter lain.'), findsOneWidget);

    await tester.tap(find.text('Transaksi baru'));
    await tester.pumpAndSettle();
    expect(host.router.canPop(), isTrue);
    expect(find.text('Buat transaksi'), findsOneWidget);
  });

  testWidgets('cancelling a note updates the history list', (tester) async {
    final host = await pumpAntrean(tester, location: '/transaksi');
    final detail = (await host.container.read(orderDetailProvider('ord-0142').future))!;
    expect(await host.container.read(orderActionsProvider.notifier).cancel(detail), isTrue);
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: find.byType(ChipBar), matching: find.text('Dibatalkan')),
    );
    await tester.pumpAndSettle();
    expect(find.text('A-0142'), findsOneWidget);
    expect(find.text('Dibatalkan'), findsWidgets);
  });
}
