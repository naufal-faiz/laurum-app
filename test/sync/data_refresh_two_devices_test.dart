import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/persistence/account_store.dart';
import 'package:laurum/core/persistence/drift_repository_overrides.dart';
import 'package:laurum/core/persistence/drift_sync_cursor_store.dart';
import 'package:laurum/core/persistence/drift_sync_outbox_store.dart';
import 'package:laurum/core/persistence/drift_sync_remote_applier.dart';
import 'package:laurum/core/persistence/drift_sync_service.dart';
import 'package:laurum/core/persistence/storage_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/sync/sync_coordinator.dart';
import 'package:laurum/core/sync/sync_engine.dart';
import 'package:laurum/core/sync/sync_pull_runner.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/sync/state/data_refresh_actions.dart';

import '../drift_app_harness.dart';
import '../persistence/sync_wire_rows.dart';
import 'refresh_memory_server.dart';

void main() {
  test('device B refresh pulls device A changes without login or resetting store', () async {
    final a = await driftAppHarness(seed: false), b = await driftAppHarness(seed: false);
    final server = RefreshMemoryServer(demoOwnerId);
    SyncCoordinator cycle(AccountStore store) => SyncCoordinator(
      SyncEngine(DriftSyncOutboxStore(store.db), server),
      SyncPullRunner(
        server,
        DriftSyncCursorStore(store.db),
        DriftSyncRemoteApplier(store.db, demoOwnerId),
      ),
    );
    final sync = DriftSyncService(b.store.db, cycle: cycle(b.store));
    await sync.start();
    final scope = ProviderContainer(
      overrides: [
        ...driftRepositoryOverrides(auth: b.container.read(authServiceProvider))
            .where((o) => o.origin != syncServiceProvider),
        accountStoreProvider.overrideWith((ref) async => b.store),
        syncServiceProvider.overrideWithValue(sync),
      ],
    );
    addTearDown(() async {
      scope.dispose();
      await sync.dispose();
      for (final app in [a, b]) {
        app.container.dispose();
        await app.store.dispose();
        await app.store.db.close();
      }
    });
    await scope.read(accountStoreProvider.future);
    final actions = scope.read(dataRefreshActionsProvider.notifier);
    await cycle(a.store).run();
    await actions.refresh();
    scope.listen(customerDirectoryProvider, (_, _) {});
    scope.listen(antreanDataProvider, (_, _) {});
    expect((await scope.read(customerDirectoryProvider.future)).single.customer.name, ' Sari ');
    final customer = (await a.store.customers.getCustomers()).single;
    await a.store.customers.saveCustomer(
      Customer(
        id: customer.id,
        ownerId: customer.ownerId,
        createdAt: customer.createdAt,
        updatedAt: DateTime(2026, 11, 16, 12),
        name: 'Nama dari perangkat A',
        phone: customer.phone,
        address: customer.address,
      ),
    );
    expect((await cycle(a.store).run()).succeeded, isTrue);
    expect((await scope.read(customerDirectoryProvider.future)).single.customer.name, ' Sari ');
    final pulls = server.pulls;
    await actions.refresh();
    expect(server.pulls, greaterThan(pulls));
    expect(
      (await scope.read(customerDirectoryProvider.future)).single.customer.name,
      'Nama dari perangkat A',
    );
    expect(
      (await scope.read(antreanDataProvider.future)).customer(wireCustomer),
      'Nama dari perangkat A',
    );
    expect(await scope.read(accountStoreProvider.future), same(b.store));
    expect(await DriftSyncOutboxStore(b.store.db).pendingCount(), 0);
  });
}
