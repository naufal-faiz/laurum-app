import 'package:laurum/core/sync/in_memory_outbox_store.dart';

import 'sync_store_contract.dart';

void main() {
  runSyncStoreContract(
    name: 'InMemory',
    store: InMemoryOutboxStore.new,
    seedGroup: (store, group) async => (store as InMemoryOutboxStore).addGroup(group),
    seedLegacy: (store, changes) async => (store as InMemoryOutboxStore).addLegacy(changes),
    teardown: () async {},
  );
}
