enum SyncPullStatus { selesai, gagal }

class SyncPullResult {
  const SyncPullResult({
    required this.status,
    required this.tablesPulled,
    required this.appliedRows,
    this.code,
  });

  final SyncPullStatus status;
  final int tablesPulled;
  final int appliedRows;
  final String? code;

  bool get succeeded => status == SyncPullStatus.selesai;
}
