import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/sync/in_memory_outbox_store.dart';
import 'package:laurum/core/sync/sync_change.dart';
import 'package:laurum/core/sync/sync_engine.dart';
import 'package:laurum/core/sync/sync_group.dart';
import 'package:laurum/core/sync/sync_run_result.dart';

import 'fake_sync_transport.dart';

void main() {
  SyncChange change(String id, {String table = 'customers'}) => SyncChange(
    changeId: id,
    table: table,
    rowId: 'row-$id',
    op: 'upsert',
    payload: {'id': 'row-$id'},
  );
  SyncGroup group(String id, List<SyncChange> changes) => SyncGroup(id, changes);

  test('commits groups in order and acknowledges them', () async {
    final store = InMemoryOutboxStore(
      groups: [
        group('g1', [change('a'), change('b')]),
        group('g2', [change('c')]),
      ],
    );
    final transport = FakeSyncTransport();
    final result = await SyncEngine(store, transport).run();
    expect(result.status, SyncRunStatus.selesai);
    expect(result.committedGroups, 2);
    expect(result.pendingChanges, 0);
    expect(transport.requests.map((r) => r.groupId), ['g1', 'g2']);
  });

  test('a rejected group stops and blocks later groups', () async {
    final store = InMemoryOutboxStore(
      groups: [
        group('g1', [change('a'), change('b')]),
        group('g2', [change('c')]),
      ],
    );
    final transport = FakeSyncTransport(rejectChangeIds: {'a'});
    final result = await SyncEngine(store, transport).run();
    expect(result.status, SyncRunStatus.konflik);
    expect(result.code, 'unique_conflict');
    expect(await store.pendingCount(), 3);
    expect(await store.conflictCount(), 2);
    expect((await store.nextGroup())!.groupId, 'g2');
  });

  test('large groups travel as fragments with one group hash', () async {
    final changes = [for (var i = 0; i < 120; i++) change('c$i')];
    final store = InMemoryOutboxStore(groups: [group('g1', changes)]);
    final transport = FakeSyncTransport();
    final result = await SyncEngine(store, transport).run();
    expect(result.status, SyncRunStatus.selesai);
    expect(transport.requests.map((r) => r.fragmentIndex), [1, 2, 3]);
    expect(transport.requests.map((r) => r.fragmentCount), [3, 3, 3]);
    expect(transport.requests.map((r) => r.groupHash).toSet(), hasLength(1));
    expect(transport.requests.map((r) => r.changes.length), [50, 50, 20]);
    expect(await store.pendingCount(), 0);
  });

  test('a lost response leaves the group pending; retry reuses the receipt', () async {
    final store = InMemoryOutboxStore(
      groups: [
        group('g1', [change('a')]),
      ],
    );
    final transport = FakeSyncTransport(loseResponseOnce: true);
    final first = await SyncEngine(store, transport).run();
    expect(first.status, SyncRunStatus.gagal);
    expect(await store.pendingCount(), 1);
    final retry = await SyncEngine(store, transport).run();
    expect(retry.status, SyncRunStatus.selesai);
    expect(await store.pendingCount(), 0);
    expect(transport.requests, hasLength(2));
  });

  test('legacy or conflicted queues block without touching the transport', () async {
    final legacy = InMemoryOutboxStore(legacy: [change('l')]);
    final legacyResult = await SyncEngine(legacy, FakeSyncTransport()).run();
    expect(legacyResult.status, SyncRunStatus.legacy);
    final conflicted = InMemoryOutboxStore(
      groups: [
        group('g1', [change('a')]),
      ],
    );
    await conflicted.markConflict('g1', 'unique_conflict');
    final conflictResult = await SyncEngine(conflicted, FakeSyncTransport()).run();
    expect(conflictResult.status, SyncRunStatus.konflik);
  });
}
