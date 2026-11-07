import 'package:laurum/core/sync/sync_change.dart';
import 'package:laurum/core/sync/sync_group.dart';
import 'package:laurum/core/sync/sync_hash.dart';
import 'package:laurum/core/sync/sync_outbox_store.dart';
import 'package:laurum/core/sync/sync_push_request.dart';
import 'package:laurum/core/sync/sync_push_result.dart';
import 'package:laurum/core/sync/sync_run_result.dart';
import 'package:laurum/core/sync/sync_transport.dart';

class SyncEngine {
  SyncEngine(this.store, this.transport);
  final SyncOutboxStore store;
  final SyncTransport transport;
  static const maxChangesPerRequest = 50;
  static const maxChangesPerGroup = 5000;

  Future<SyncRunResult> run() async {
    if (await store.conflictCount() > 0) {
      return _blocked(SyncRunStatus.konflik, 0, 'unresolved_conflict');
    }
    if (await store.legacyCount() > 0) {
      return _blocked(SyncRunStatus.legacy, 0, 'legacy_queue');
    }
    var committed = 0;
    while (true) {
      final group = await store.nextGroup();
      if (group == null) break;
      if (group.changes.length > maxChangesPerGroup) {
        await store.markConflict(group.groupId, 'group_too_large');
        return _blocked(SyncRunStatus.konflik, committed, 'group_too_large');
      }
      final receipt = await _send(group);
      if (receipt == null) return _blocked(SyncRunStatus.gagal, committed, 'transport_failure');
      if (receipt.status == SyncGroupStatus.rejected) {
        await store.markConflict(group.groupId, receipt.code ?? 'rejected');
        return _blocked(SyncRunStatus.konflik, committed, receipt.code ?? 'rejected');
      }
      if (receipt.status != SyncGroupStatus.committed) {
        await store.markConflict(group.groupId, 'staged_after_last_fragment');
        return _blocked(SyncRunStatus.konflik, committed, 'staged_after_last_fragment');
      }
      final sent = {for (final change in group.changes) change.changeId};
      if (!sent.every(receipt.acknowledged.contains)) {
        await store.markConflict(group.groupId, 'partial_receipt');
        return _blocked(SyncRunStatus.konflik, committed, 'partial_receipt');
      }
      await store.ackGroup(group.groupId, receipt.acknowledged);
      committed++;
    }
    return SyncRunResult(
      status: SyncRunStatus.selesai,
      committedGroups: committed,
      pendingChanges: await store.pendingCount(),
    );
  }

  Future<SyncPushResult?> _send(SyncGroup group) async {
    final changes = group.changes;
    final groupHash = syncHash([for (final change in changes) change.toJson()]);
    final fragments = _fragments(changes);
    for (var index = 0; index < fragments.length; index++) {
      final fragment = fragments[index];
      final request = SyncPushRequest(
        groupId: group.groupId,
        groupHash: groupHash,
        fragmentIndex: index + 1,
        fragmentCount: fragments.length,
        fragmentHash: syncHash([for (final change in fragment) change.toJson()]),
        changes: fragment,
      );
      try {
        final result = await transport.push(request);
        if (result.groupId != request.groupId) throw StateError('group_mismatch');
        if (result.status == SyncGroupStatus.staged) {
          if (index == fragments.length - 1) return result;
          continue;
        }
        return result;
      } catch (_) {
        await store.recordFailure(request.groupId, 'transport_failure');
        return null;
      }
    }
    return null;
  }

  Future<SyncRunResult> _blocked(SyncRunStatus status, int committed, String code) async =>
      SyncRunResult(
        status: status,
        committedGroups: committed,
        pendingChanges: await store.pendingCount(),
        code: code,
      );

  static List<List<SyncChange>> _fragments(List<SyncChange> changes) => [
    for (var start = 0; start < changes.length; start += maxChangesPerRequest)
      changes.sublist(
        start,
        start + maxChangesPerRequest < changes.length
            ? start + maxChangesPerRequest
            : changes.length,
      ),
  ];
}
