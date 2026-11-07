import 'package:laurum/core/sync/sync_change.dart';
import 'package:laurum/core/sync/sync_group.dart';

abstract interface class SyncOutboxStore {
  Future<SyncGroup?> nextGroup();
  Future<int> pendingCount();
  Future<int> conflictCount();
  Future<int> legacyCount();
  Future<List<SyncChange>> legacyChanges();
  Future<void> ackGroup(String groupId, Set<String> changeIds);
  Future<void> recordFailure(String groupId, String code);
  Future<void> markConflict(String groupId, String code);
  Future<void> recoverLegacyGroup(String groupId, List<String> changeIds);
}
