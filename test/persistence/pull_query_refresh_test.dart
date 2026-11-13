import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/drift_sync_remote_applier.dart';
import 'package:laurum/core/persistence/storage_providers.dart';
import 'package:laurum/core/sync/sync_table_names.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';

import '../drift_app_harness.dart';
import 'sync_wire_rows.dart';

void main() {
  test('mounted customer and queue queries update from zero after a remote pull', () async {
    final app = await driftAppHarness(seed: false);
    addTearDown(() async {
      app.container.dispose();
      await app.store.dispose();
      await app.store.db.close();
    });
    app.container.listen(customerDirectoryProvider, (_, _) {});
    app.container.listen(antreanDataProvider, (_, _) {});
    expect(await app.container.read(customerDirectoryProvider.future), isEmpty);
    expect((await app.container.read(antreanDataProvider.future)).orders, isEmpty);
    final rows = allWireRows();
    final applier = DriftSyncRemoteApplier(app.store.db, demoOwnerId);
    for (var index = 0; index < syncPullOrder.length; index++) {
      await applier.apply(syncPullOrder[index], [
        {...rows[index], 'owner_id': demoOwnerId},
      ]);
    }
    await pumpEventQueue();
    expect(await app.container.read(customerDirectoryProvider.future), hasLength(1));
    expect((await app.container.read(antreanDataProvider.future)).orders, hasLength(1));
  });
}
