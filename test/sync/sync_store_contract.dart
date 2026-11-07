import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/sync/sync_change.dart';
import 'package:laurum/core/sync/sync_group.dart';
import 'package:laurum/core/sync/sync_outbox_store.dart';

SyncChange change(String id, {String table = 'customers'}) => SyncChange(
  changeId: id,
  table: table,
  rowId: 'row-$id',
  op: 'upsert',
  payload: {'id': 'row-$id'},
);

void runSyncStoreContract({
  required String name,
  required SyncOutboxStore Function() store,
  required Future<void> Function(SyncOutboxStore store, SyncGroup group) seedGroup,
  required Future<void> Function(SyncOutboxStore store, List<SyncChange> changes) seedLegacy,
  required Future<void> Function() teardown,
}) {
  group('$name sync outbox store', () {
    late SyncOutboxStore target;
    setUp(() => target = store());
    tearDown(teardown);

    test('returns the oldest group in sequence order', () async {
      final first = [change('a1'), change('a2')];
      await seedGroup(target, SyncGroup('11111111-1111-4111-8111-111111111111', first));
      await seedGroup(target, SyncGroup('22222222-2222-4222-8222-222222222222', [change('b1')]));
      final group = await target.nextGroup();
      expect(group!.groupId, '11111111-1111-4111-8111-111111111111');
      expect(group.changes.map((c) => c.changeId), ['a1', 'a2']);
      expect(await target.pendingCount(), 3);
    });

    test('ack deletes only the sent ids', () async {
      final a = change('a1'), b = change('b1');
      await seedGroup(target, SyncGroup('11111111-1111-4111-8111-111111111111', [a]));
      await seedGroup(target, SyncGroup('22222222-2222-4222-8222-222222222222', [b]));
      await target.ackGroup('11111111-1111-4111-8111-111111111111', {a.changeId});
      expect(await target.pendingCount(), 1);
      final next = await target.nextGroup();
      expect(next!.changes.single.changeId, 'b1');
    });

    test('ack inside one group never removes an id that was not sent', () async {
      await seedGroup(
        target,
        SyncGroup('11111111-1111-4111-8111-111111111111', [change('a1'), change('a2')]),
      );
      await target.ackGroup('11111111-1111-4111-8111-111111111111', {'a1'});
      expect(await target.pendingCount(), 1);
      expect((await target.nextGroup())!.changes.single.changeId, 'a2');
    });

    test('failure keeps the group pending; conflict blocks it', () async {
      await seedGroup(target, SyncGroup('11111111-1111-4111-8111-111111111111', [change('a1')]));
      await target.recordFailure('11111111-1111-4111-8111-111111111111', 'transport_failure');
      expect(await target.pendingCount(), 1);
      expect(await target.nextGroup(), isNotNull);
      await target.markConflict('11111111-1111-4111-8111-111111111111', 'unique_conflict');
      expect(await target.conflictCount(), 1);
      expect(await target.nextGroup(), isNull);
    });

    test('legacy rows stay blocked until an explicit recovery plan', () async {
      await seedLegacy(target, [change('l1'), change('l2')]);
      expect(await target.legacyCount(), 2);
      expect((await target.legacyChanges()).map((c) => c.changeId), ['l1', 'l2']);
      expect(await target.nextGroup(), isNull);
      await target.recoverLegacyGroup(
        '33333333-3333-4333-8333-333333333333',
        ['l1', 'l2'],
      );
      expect(await target.legacyCount(), 0);
      final recovered = await target.nextGroup();
      expect(recovered!.groupId, '33333333-3333-4333-8333-333333333333');
      expect(recovered.changes.map((c) => c.changeId), ['l1', 'l2']);
    });

    test('recovery rejects duplicate or unknown ids', () async {
      await seedLegacy(target, [change('l1')]);
      await expectLater(
        target.recoverLegacyGroup('33333333-3333-4333-8333-333333333333', ['l1', 'l1']),
        throwsArgumentError,
      );
      await expectLater(
        target.recoverLegacyGroup('33333333-3333-4333-8333-333333333333', ['missing']),
        throwsStateError,
      );
    });
  });
}
