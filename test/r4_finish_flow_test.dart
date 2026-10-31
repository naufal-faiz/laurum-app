import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/shared/widgets/organisms/confirm_modal.dart';

import 'antrean_test_host.dart';
import 'r4_completion_test_host.dart';
import 'r4_finish_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final action in ['success', 'fallback', 'delete']) {
    testWidgets('toggle off -> checkout -> $action preserves ledger and updates queue', (
      tester,
    ) async {
      final printer = CompletionPrinter(printSucceeds: action != 'fallback');
      final scope = await completionScope(printer, tracking: true);
      final host = await pumpAntrean(tester, container: scope, location: '/lainnya');
      final before = (await scope.read(customerSummariesProvider.future))
          .singleWhere((r) => r.customer.id == 'cust-001');
      await tapStatusSwitch(tester);
      expect((await scope.read(businessRepositoryProvider).getProfile()).useOrderStatus, isFalse);
      final id = await createR4Order(tester, scope, savings: action == 'delete');
      expect(find.text('Sedang dikerjakan'), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Hapus'), findsOneWidget);
      expect(find.text('Selesaikan'), findsOneWidget);
      expect(find.byTooltip('Menu order'), findsNothing);
      final repo = scope.read(orderRepositoryProvider);
      expect((await repo.getEventsByOrderId(id)).single.toStatus, OrderStatus.diproses);
      if (action == 'delete') {
        expect(
          await scope.read(savingsRepositoryProvider).getBalance('cust-001'),
          before.savings - 9000,
        );
        await tester.tap(find.text('Hapus'));
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
        if (action == 'fallback') {
          expect((await repo.getOrderById(id))!.status, OrderStatus.diproses);
          expect(
            (await scope.read(antreanDataProvider.future)).orders.map((o) => o.id),
            contains(id),
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
        }
        expect((await repo.getOrderById(id))!.status, OrderStatus.selesai);
        expect(printer.calls, 1);
        expect(await repo.getPaymentsByOrderId(id), isEmpty);
      }
      host.router.go('/antrean');
      await tester.pumpAndSettle();
      expect(
        (await scope.read(antreanDataProvider.future)).orders.map((o) => o.id),
        isNot(contains(id)),
      );
      final after = (await scope.read(customerSummariesProvider.future))
          .singleWhere((r) => r.customer.id == 'cust-001');
      expect(after.debt, before.debt + (action == 'delete' ? 0 : 9000));
      expect(tester.takeException(), isNull);
    });
  }
}
