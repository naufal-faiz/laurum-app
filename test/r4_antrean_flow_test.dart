import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/pages/antrean_page.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';

import 'antrean_test_host.dart';
import 'r4_completion_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final width in [390, 320]) {
    testWidgets('simplified queue $width opens Detail and removes completed unpaid order', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width.toDouble(), 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final printer = CompletionPrinter();
      final scope = await completionScope(printer);
      await pumpAntrean(tester, container: scope, textScale: width == 320 ? 2 : 1);
      final scroll = find
          .descendant(of: find.byType(AntreanPage), matching: find.byType(Scrollable))
          .first;
      final card = find.byKey(const ValueKey('ord-0142'));
      await tester.scrollUntilVisible(card, 300, scrollable: scroll);
      await tester.pumpAndSettle();
      expect(find.descendant(of: card, matching: find.text('Sedang dikerjakan')), findsOneWidget);
      for (final action in ['Tandai dijemput', 'Tandai siap', 'Serahkan']) {
        expect(find.text(action), findsNothing);
      }
      if (width == 390) {
        await expectLater(
          find.byKey(const ValueKey('antrean-golden')),
          matchesGoldenFile('goldens/r4_antrean_sederhana.png'),
        );
      }
      await tester.tap(find.descendant(of: card, matching: find.text('A-0142')));
      await tester.pumpAndSettle();
      expect(find.text('Detail order'), findsOneWidget);
      expect(find.byTooltip('Menu order'), findsNothing);
      await tester.tap(find.text('Selesaikan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cetak struk'));
      await tester.pumpAndSettle();
      expect(printer.calls, 1);
      final repo = scope.read(orderRepositoryProvider);
      expect((await repo.getOrderById('ord-0142'))!.status, OrderStatus.selesai);
      expect(await repo.getPaymentsByOrderId('ord-0142'), isEmpty);
      await tester.tap(find.byTooltip('Kembali'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Semua 11'), -300, scrollable: scroll);
      expect(tester.widget<ChipBar>(find.byType(ChipBar)).labels, ['Semua 11', 'Perlu dicek 3']);
      expect(
        (await scope.read(antreanDataProvider.future)).orders.map((o) => o.id),
        isNot(contains('ord-0142')),
      );
      expect(tester.takeException(), isNull);
    });
  }
}
