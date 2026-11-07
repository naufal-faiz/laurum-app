import 'package:laurum/core/sync/sync_change.dart';

class SyncGroup {
  const SyncGroup(this.groupId, this.changes);
  final String groupId;
  final List<SyncChange> changes;
}
