import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/persistence/drift_repository_overrides.dart';
import 'package:laurum/core/persistence/drift_sync_remote_applier.dart';
import 'package:laurum/core/persistence/storage_providers.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/reports/state/report_view.dart';
import 'package:laurum/features/shell/pages/app_router.dart';
import 'package:laurum/shared/widgets/atoms/app_loader.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';

import 'drift_app_harness.dart';
import 'held_customer_repository.dart';
import 'persistence/sync_wire_rows.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final route in [
    '/beranda',
    '/antrean',
    '/pelanggan',
    '/pelanggan/impor',
    '/order/{id}',
    '/transaksi/nota/{id}',
  ]) {
    testWidgets('sync keeps $route mounted while local queries reload', (tester) async {
      final app = (await tester.runAsync(driftAppHarness))!;
      final orderId = (await tester.runAsync(app.store.orders.getOrders))!.first.id;
      Completer<void>? pending;
      final scope = ProviderContainer(
        overrides: [
          ...driftRepositoryOverrides(auth: app.container.read(authServiceProvider))
              .where((override) => override.origin != customerRepositoryProvider),
          accountStoreProvider.overrideWith((ref) async => app.store),
          customerRepositoryProvider.overrideWith((ref) {
            final store = requireAccountStore(ref);
            return HeldCustomerRepository(
              store.db,
              store.ownerId,
              store.writer,
              waitForReads: () => pending?.future ?? Future.value(),
            );
          }),
        ],
      );
      final router = createAppRouter(
        container: scope,
        initialLocation: route.replaceAll('{id}', orderId),
      );
      addTearDown(() async {
        if (pending != null && !pending.isCompleted) pending.complete();
        await tester.pumpWidget(const SizedBox.shrink());
        router.dispose();
        scope.dispose();
        app.container.dispose();
        await app.store.dispose();
        await app.store.db.close();
      });
      await tester.runAsync(() async {
        await scope.read(accountStoreProvider.future);
        await Future.wait([
          scope.read(antreanDataProvider.future),
          scope.read(customerDirectoryProvider.future),
          scope.read(weeklyReportViewProvider.future),
        ]);
      });
      await pumpDriftApp(tester, scope, router);
      await tester.pumpAndSettle();
      final navigation = tester.element(find.byType(Navigator).first);
      pending = Completer<void>();
      await tester.runAsync(
        () => DriftSyncRemoteApplier(app.store.db, demoOwnerId).apply('customers', [
          {
            ...customerRow(owner: demoOwnerId),
            'phone': '089000011111',
            'name': 'Data sinkron baru',
          },
        ]),
      );
      for (var frame = 0; frame < 3; frame++) {
        await tester.pump();
        expect(find.byType(AppLoader), findsNothing);
        expect(find.byType(AppSkeleton), findsNothing);
        expect(tester.element(find.byType(Navigator).first), same(navigation));
      }
      pending.complete();
      await tester.runAsync(
        () => Future.wait([
          scope.read(antreanDataProvider.future),
          scope.read(customerDirectoryProvider.future),
          scope.read(weeklyReportViewProvider.future),
        ]),
      );
      await tester.pumpAndSettle();
      expect(
        (await scope.read(customerDirectoryProvider.future))
            .any((row) => row.customer.name == 'Data sinkron baru'),
        isTrue,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
