import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';

import 'antrean_test_host.dart';
import 'r4_completion_test_host.dart';
import 'r4_finish_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final action in ['success', 'retry', 'delete']) {
    testWidgets('toggle off -> checkout -> $action preserves ledger and updates queue', (
      tester,
    ) async {
      final printer = CompletionPrinter(printSucceeds: action != 'retry');
      final scope = await completionScope(printer, tracking: true);
      final host = await pumpAntrean(tester, container: scope, location: '/lainnya');
      final before = (await scope.read(customerSummariesProvider.future))
          .singleWhere((r) => r.customer.id == 'cust-001');
      await tapStatusSwitch(tester);
      expect((await scope.read(businessRepositoryProvider).getProfile()).useOrderStatus, isFalse);
      final id = await createR4Order(tester, scope, savings: action == 'delete');
      expect(find.text('Sedang dikerjakan'), findsOneWidget);
      expect(find.byTooltip('Edit'), findsOneWidget);
      expect(find.byTooltip('Hapus'), findsOneWidget);
      expect(find.text('Selesaikan'), findsOneWidget);
      expect(find.byTooltip('Menu order'), findsNothing);
      final repo = scope.read(orderRepositoryProvider);
      expect((await repo.getEventsByOrderId(id)).single.toStatus, OrderStatus.diproses);
      if (action == 'delete') {
        expect(
          await scope.read(savingsRepositoryProvider).getBalance('cust-001'),
          before.savings - 9000,
        );
        await tester.tap(find.byTooltip('Hapus'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Ya, hapus nota'));
        await tester.pumpAndSettle();
        expect((await repo.getOrderById(id))!.status, OrderStatus.dibatalkan);
        expect(printer.calls, 0);
        expect(await scope.read(savingsRepositoryProvider).getBalance('cust-001'), before.savings);
      } else {
        await tester.tap(find.text('Selesaikan'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Cetak struk'));
        await tester.pumpAndSettle();
        expect(printer.calls, 0);
        await tester.ensureVisible(find.byTooltip('Cetak struk'));
        await tester.tap(find.byTooltip('Cetak struk'));
        await tester.pumpAndSettle();
        if (action == 'retry') {
          expect((await repo.getOrderById(id))!.status, OrderStatus.diproses);
          expect(
            (await scope.read(antreanDataProvider.future)).orders.map((o) => o.id),
            contains(id),
          );
          expect(find.text('Selesaikan tanpa cetak'), findsNothing);
          printer.printSucceeds = true;
          await printer.connect(printer.devices.first);
          await tester.ensureVisible(find.byTooltip('Coba lagi'));
          await tester.tap(find.byTooltip('Coba lagi'));
          await tester.pumpAndSettle();
        }
        expect((await repo.getOrderById(id))!.status, OrderStatus.selesai);
        expect(printer.calls, action == 'retry' ? 2 : 1);
        final recorded = await repo.getPaymentsByOrderId(id);
        expect(recorded.single.amount, 1000);
      }
      host.router.go('/antrean');
      await tester.pumpAndSettle();
      expect(
        (await scope.read(antreanDataProvider.future)).orders.map((o) => o.id),
        isNot(contains(id)),
      );
      final after = (await scope.read(customerSummariesProvider.future))
          .singleWhere((r) => r.customer.id == 'cust-001');
      expect(after.debt, before.debt + (action == 'delete' ? 0 : 8000));
      expect(tester.takeException(), isNull);
    });
  }
}
