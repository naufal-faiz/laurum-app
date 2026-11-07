abstract interface class SyncRemoteApplier {
  Future<void> apply(String table, List<Map<String, Object?>> rows);
}
