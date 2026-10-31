import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/shared/widgets/organisms/confirm_modal.dart';

import 'antrean_test_host.dart';
import 'r4_completion_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final cancelled in [false, true]) {
    testWidgets('print cancelled=$cancelled requires separate fallback confirmation', (
      tester,
    ) async {
      final printer = CompletionPrinter(printSucceeds: false);
      final scope = await completionScope(printer);
      await pumpAntrean(tester, container: scope, location: '/order/ord-0142');
      await tester.tap(find.text('Selesaikan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(cancelled ? 'Batal' : 'Cetak struk'));
      await tester.pumpAndSettle();
      expect(printer.calls, cancelled ? 0 : 1);
      expect(
        (await scope.read(orderRepositoryProvider).getOrderById('ord-0142'))!.status,
        OrderStatus.diproses,
      );
      expect(find.text('Selesaikan tanpa cetak'), findsOneWidget);
      await tester.tap(find.text('Selesaikan tanpa cetak'));
      await tester.pumpAndSettle();
      expect(find.text('Selesaikan tanpa cetak?'), findsOneWidget);
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();
      expect(
        (await scope.read(orderRepositoryProvider).getOrderById('ord-0142'))!.status,
        OrderStatus.diproses,
      );
      await tester.tap(find.text('Selesaikan tanpa cetak'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(ConfirmModal),
          matching: find.text('Selesaikan tanpa cetak'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Selesai'), findsOneWidget);
      expect(find.text('Selesaikan tanpa cetak'), findsNothing);
      expect(
        find.text('Struk gagal dicetak. Pastikan printer menyala dan Bluetooth aktif.'),
        findsNothing,
      );
      expect(printer.calls, cancelled ? 0 : 1);
      expect(tester.takeException(), isNull);
    });
  }
}
