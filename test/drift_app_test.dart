import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/app.dart';
import 'package:laurum/core/persistence/demo_fixture_id.dart';
import 'package:laurum/core/persistence/storage_providers.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/orders/widgets/antrean_header_section.dart';
import 'package:laurum/features/shell/pages/app_router.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';

import 'drift_app_harness.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('Drift application displays seed, creates receipt and refreshes queue', (
    tester,
  ) async {
    final app = await tester.runAsync(driftAppHarness);
    final container = app!.container, store = app.store;
    addTearDown(() async {
      container.dispose();
      await store.dispose();
      await store.db.close();
    });
    final router = createAppRouter(container: container, initialLocation: '/antrean');
    addTearDown(router.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: LaurumApp(router: router),
      ),
    );
    await tester.runAsync(() => container.read(antreanDataProvider.future));
    await tester.pumpAndSettle();
    expect(find.byType(AntreanHeaderSection), findsOneWidget);
    expect(find.text('12 order aktif'), findsOneWidget);
    await tester.runAsync(() async {
      final service = (await store.services.getServices()).firstWhere(
        (s) => s.name == 'Cuci setrika',
      );
      container.read(transactionDraftProvider.notifier)
        ..selectCustomer(demoFixtureId(demoOwnerId, 'cust-001'))
        ..add(service)
        ..setQuantity(service.id, 1000);
      final checkout = container.read(checkoutControllerProvider.notifier)
        ..setReceived(10000, due: 9000);
      final id = await checkout.save();
      expect(id, isNotNull);
      final order = await store.orders.getOrderById(id!);
      expect(order!.orderNo, 'A-0143');
      expect(order.total, 9000);
      router.go('/transaksi/nota/$id');
    });
    await tester.pumpAndSettle();
    expect(find.textContaining('A-0143'), findsWidgets);
    router.go('/antrean');
    await tester.runAsync(() => container.read(antreanDataProvider.future));
    await tester.pumpAndSettle();
    expect(find.text('13 order aktif'), findsOneWidget);
    expect(container.read(orderRepositoryProvider), same(store.orders));
    expect(tester.takeException(), isNull);
  });
}
