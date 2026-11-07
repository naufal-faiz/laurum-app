import 'package:laurum/core/sync/sync_change.dart';
import 'package:laurum/core/sync/sync_hash.dart';
import 'package:laurum/core/sync/sync_push_request.dart';
import 'package:laurum/core/sync/sync_push_result.dart';
import 'package:laurum/core/sync/sync_transport.dart';

// Test double of the B2a server: fragment staging, canonical hashes, stable receipts.
class FakeSyncTransport implements SyncTransport {
  FakeSyncTransport({this.rejectChangeIds = const {}, this.loseResponseOnce = false});
  final Set<String> rejectChangeIds;
  bool loseResponseOnce;
  final List<SyncPushRequest> requests = [];
  final Map<String, Map<int, List<SyncChange>>> _fragments = {};
  final Map<String, SyncPushResult> _receipts = {};

  @override
  Future<SyncPushResult> push(SyncPushRequest request) async {
    requests.add(request);
    final stored = _receipts[request.groupId];
    if (stored != null) return stored;
    if (syncHash([for (final c in request.changes) c.toJson()]) != request.fragmentHash) {
      throw StateError('fragment_hash_mismatch');
    }
    final fragments = _fragments.putIfAbsent(request.groupId, () => {});
    fragments[request.fragmentIndex] = request.changes;
    if (fragments.length < request.fragmentCount) {
      return SyncPushResult(
        groupId: request.groupId,
        status: SyncGroupStatus.staged,
        received: fragments.length,
        expected: request.fragmentCount,
      );
    }
    final full = [
      for (var index = 1; index <= request.fragmentCount; index++) ...?fragments[index],
    ];
    if (syncHash([for (final c in full) c.toJson()]) != request.groupHash) {
      throw StateError('group_hash_mismatch');
    }
    final rejected =
        rejectChangeIds.isNotEmpty && full.any((c) => rejectChangeIds.contains(c.changeId));
    final receipt = SyncPushResult(
      groupId: request.groupId,
      status: rejected ? SyncGroupStatus.rejected : SyncGroupStatus.committed,
      code: rejected ? 'unique_conflict' : null,
      results: [
        for (final c in full)
          SyncChangeResult(
            changeId: c.changeId,
            status: rejected ? 'ditolak' : 'ok',
            code: rejected ? 'unique_conflict' : null,
          ),
      ],
    );
    _receipts[request.groupId] = receipt;
    if (loseResponseOnce) {
      loseResponseOnce = false;
      throw StateError('response_lost_after_commit');
    }
    return receipt;
  }
}
