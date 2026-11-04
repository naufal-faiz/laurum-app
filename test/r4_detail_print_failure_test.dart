import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/repository_providers.dart';

import 'antrean_test_host.dart';
import 'r4_completion_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final cancelled in [false, true]) {
    testWidgets('print cancelled=$cancelled keeps active with no bypass', (tester) async {
      final printer = CompletionPrinter(printSucceeds: false);
      final scope = await completionScope(printer);
      final host = await pumpAntrean(tester, container: scope, location: '/order/ord-0142');
      await tester.tap(find.text('Selesaikan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(cancelled ? 'Batal' : 'Cetak struk'));
      await tester.pumpAndSettle();
      if (!cancelled) {
        expect(find.text('Nota tersimpan'), findsOneWidget);
        expect(printer.calls, 0);
        await tester.ensureVisible(find.byTooltip('Cetak struk'));
        await tester.tap(find.byTooltip('Cetak struk'));
        await tester.pumpAndSettle();
        expect(find.textContaining('Struk gagal dicetak'), findsOneWidget);
        await tester.tap(find.byTooltip('Kembali'));
        await tester.pumpAndSettle();
      }
      expect(host.router.routeInformationProvider.value.uri.path, '/order/ord-0142');
      expect(printer.calls, cancelled ? 0 : 1);
      expect(find.text('Selesaikan tanpa cetak'), findsNothing);
      expect(
        (await scope.read(orderRepositoryProvider).getOrderById('ord-0142'))!.status,
        OrderStatus.diproses,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
