import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/id_generator_provider.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/main_dummy.dart';

import 'antrean_test_host.dart';
import 'fake_id_generator.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final mode in [false, true]) {
    testWidgets('COD cashier -> receipt -> held detail -> payment completes mode=$mode', (
      tester,
    ) async {
      final scope = ProviderContainer(
        overrides: [
          ...dummyRepositoryOverrides,
          idGeneratorProvider.overrideWithValue(FakeIdGenerator(newValues: ['ord-0143'])),
        ],
      );
      final business = scope.read(businessRepositoryProvider);
      await business.saveProfile((await business.getProfile()).withOrderStatus(enabled: mode));
      scope.read(transactionDraftProvider.notifier)
        ..selectCustomer('cust-001')
        ..add(serviceFixtures.firstWhere((s) => s.id == 'srv-004'));
      final host = await pumpAntrean(tester, container: scope, location: '/transaksi/baru/bayar');
      await tester.tap(find.text('Bayar nanti (COD)'));
      await tester.pumpAndSettle();
      expect(find.text('Uang diterima'), findsNothing);
      expect(find.text('Tunai'), findsNothing);
      await tester.tap(find.text('Cetak struk'));
      await tester.pumpAndSettle();
      expect(host.router.routeInformationProvider.value.uri.path, '/transaksi/nota/ord-0143');
      final orders = scope.read(orderRepositoryProvider);
      expect((await orders.getOrderById('ord-0143'))!.status, OrderStatus.diproses);
      expect(find.text('COD - sisa Rp25.000'), findsOneWidget);
      await tester.ensureVisible(find.text('Lihat detail'));
      await tester.tap(find.text('Lihat detail'));
      await tester.pumpAndSettle();
      if (mode) {
        await tester.tap(find.text('Tandai siap'));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text('Terima pembayaran'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Simpan pembayaran'));
      await tester.pumpAndSettle();
      final data = (await scope.read(orderDetailProvider('ord-0143').future))!;
      expect(data.order.status, OrderStatus.selesai);
      expect(data.paid, 25000);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('Ke antrean saves and shows notice once instead of opening receipt', (tester) async {
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        idGeneratorProvider.overrideWithValue(FakeIdGenerator(newValues: ['ord-0143'])),
      ],
    );
    scope.read(transactionDraftProvider.notifier)
      ..selectCustomer('cust-001')
      ..add(serviceFixtures.firstWhere((s) => s.id == 'srv-004'));
    final host = await pumpAntrean(tester, container: scope, location: '/transaksi/baru/bayar');
    await tester.tap(find.text('Ke antrean'));
    await tester.pumpAndSettle();
    expect(host.router.routeInformationProvider.value.uri.path, '/antrean');
    expect(find.text('Nota A-0143 tersimpan'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    expect(find.text('Nota A-0143 tersimpan'), findsNothing);
    expect(await scope.read(orderRepositoryProvider).getOrderById('ord-0143'), isNotNull);
  });
}
