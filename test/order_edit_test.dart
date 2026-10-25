import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/molecules/stepper_field.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  testWidgets('edit order loads the draft, changes weight and saves', (tester) async {
    final host = await pumpAntrean(tester, location: '/order/ord-0142');
    await tester.tap(find.byTooltip('Menu order'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit order'));
    await tester.pumpAndSettle();
    expect(find.text('Edit order A-0142'), findsOneWidget);
    expect(find.text('Terkunci'), findsOneWidget);
    expect(find.textContaining('Saldo tabungan: Rp50.000'), findsOneWidget);
    expect(host.container.read(transactionDraftProvider).lines.single.qtyMilli, 4500);

    await tester.tap(find.text('Cuci kiloan'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: find.byType(StepperField), matching: find.text('+')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Selesai'));
    await tester.pumpAndSettle();
    expect(find.text('5 kg · Rp35.000'), findsOneWidget);

    await tester.tap(find.text('Simpan perubahan'));
    await tester.pumpAndSettle();
    expect(find.text('Detail order'), findsOneWidget);
    final repository = host.container.read(orderRepositoryProvider);
    expect((await repository.getOrderById('ord-0142'))!.total, 35000);
    final items = await repository.getItemsByOrderId('ord-0142');
    expect(items.single.qtyMilli, 5000);
    final data = (await host.container.read(orderDetailProvider('ord-0142').future))!;
    expect(data.activity.first.label, 'Nota diperbarui');
  });

  testWidgets('edit order keeps the customer locked and warns for WhatsApp orders', (
    tester,
  ) async {
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    final repository = scope.read(orderRepositoryProvider);
    final customer = (await scope.read(customerRepositoryProvider).getCustomerById('cust-001'))!;
    final now = DateTime(2026, 10, 16, 11);
    await repository.saveOrder(
      Order(
        id: 'ord-wa',
        ownerId: customer.ownerId,
        createdAt: now,
        orderNo: 'A-0144',
        customerId: customer.id,
        status: OrderStatus.diproses,
        source: OrderSource.whatsappAi,
        discount: 0,
        enteredAt: now,
        estimatedAt: DateTime(2026, 10, 18, 17),
        subtotal: 0,
        total: 0,
      ),
    );
    await pumpAntrean(tester, container: scope, location: '/order/ord-wa/edit');
    expect(
      find.text('Order dari WhatsApp: isi berat setelah cucian ditimbang.'),
      findsOneWidget,
    );
    expect(find.text('Terkunci'), findsOneWidget);
    expect(find.text('Pilih pelanggan'), findsNothing);
  });
}
