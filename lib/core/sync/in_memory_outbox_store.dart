import 'package:laurum/core/sync/sync_change.dart';
import 'package:laurum/core/sync/sync_group.dart';
import 'package:laurum/core/sync/sync_outbox_store.dart';

class InMemoryOutboxStore implements SyncOutboxStore {
  InMemoryOutboxStore({
    Iterable<SyncGroup> groups = const [],
    Iterable<SyncChange> legacy = const [],
  }) {
    for (final group in groups) {
      addGroup(group);
    }
    for (final change in legacy) {
      _rows.add(_Row(change, null, null, requiresRecovery: true));
    }
  }
  final _rows = <_Row>[];
  static final _uuid = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$');

  void addGroup(SyncGroup group) {
    for (var index = 0; index < group.changes.length; index++) {
      _rows.add(_Row(group.changes[index], group.groupId, index + 1));
    }
  }

  void addLegacy(Iterable<SyncChange> changes) {
    for (final change in changes) {
      _rows.add(_Row(change, null, null, requiresRecovery: true));
    }
  }

  @override
  Future<SyncGroup?> nextGroup() async {
    final blocked = _rows.where(
      (r) => r.groupId != null && r.conflictCode == null && !r.requiresRecovery,
    );
    final groupId = blocked.isEmpty ? null : blocked.first.groupId;
    if (groupId == null) return null;
    final rows = _rows.where((r) => r.groupId == groupId).toList()
      ..sort((a, b) => (a.groupSeq ?? 0).compareTo(b.groupSeq ?? 0));
    return SyncGroup(groupId, [for (final row in rows) row.change]);
  }

  @override
  Future<int> pendingCount() async => _rows.length;
  @override
  Future<int> conflictCount() async => _rows.where((r) => r.conflictCode != null).length;
  @override
  Future<int> legacyCount() async => _rows.where((r) => r.requiresRecovery).length;

  @override
  Future<List<SyncChange>> legacyChanges() async => [
    for (final row in _rows.where((r) => r.requiresRecovery)) row.change,
  ];

  @override
  Future<void> ackGroup(String groupId, Set<String> changeIds) async =>
      _rows.removeWhere((r) => r.groupId == groupId && changeIds.contains(r.change.changeId));

  @override
  Future<void> recordFailure(String groupId, String code) async {
    for (final row in _rows.where((r) => r.groupId == groupId)) {
      row.attempts++;
      row.lastError = code;
    }
  }

  @override
  Future<void> markConflict(String groupId, String code) async {
    for (final row in _rows.where((r) => r.groupId == groupId)) {
      row.conflictCode = code;
      row.lastError = code;
    }
  }

  @override
  Future<void> recoverLegacyGroup(String groupId, List<String> changeIds) async {
    if (!_uuid.hasMatch(groupId) ||
        changeIds.isEmpty ||
        changeIds.toSet().length != changeIds.length) {
      throw ArgumentError('Invalid legacy recovery plan');
    }
    for (var index = 0; index < changeIds.length; index++) {
      final row = _rows
          .where((r) => r.change.changeId == changeIds[index] && r.requiresRecovery)
          .firstOrNull;
      if (row == null) throw StateError('Legacy row is missing or already recovered');
      row.groupId = groupId;
      row.groupSeq = index + 1;
      row.requiresRecovery = false;
    }
  }
}

class _Row {
  _Row(this.change, this.groupId, this.groupSeq, {this.requiresRecovery = false});
  final SyncChange change;
  String? groupId;
  int? groupSeq;
  bool requiresRecovery;
  String? conflictCode;
  String? lastError;
  int attempts = 0;
}
