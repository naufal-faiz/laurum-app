import 'package:laurum/core/sync/sync_change.dart';

class SyncPushRequest {
  const SyncPushRequest({
    required this.groupId,
    required this.groupHash,
    required this.fragmentIndex,
    required this.fragmentCount,
    required this.fragmentHash,
    required this.changes,
  });
  final String groupId;
  final String groupHash;
  final int fragmentIndex;
  final int fragmentCount;
  final String fragmentHash;
  final List<SyncChange> changes;

  Map<String, Object?> toJson() => {
    'p_changes': [for (final change in changes) change.toJson()],
    'p_group_id': groupId,
    'p_group_hash': groupHash,
    'p_fragment_index': fragmentIndex,
    'p_fragment_count': fragmentCount,
    'p_fragment_hash': fragmentHash,
  };
}
