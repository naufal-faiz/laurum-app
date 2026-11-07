enum SyncRunStatus { selesai, konflik, legacy, gagal }

class SyncRunResult {
  const SyncRunResult({
    required this.status,
    required this.committedGroups,
    required this.pendingChanges,
    this.code,
  });
  final SyncRunStatus status;
  final int committedGroups;
  final int pendingChanges;
  final String? code;
  bool get succeeded => status == SyncRunStatus.selesai;
}
