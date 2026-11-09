import 'dart:async';

export 'package:laurum/core/services/fake_sync_service.dart';

enum SyncServiceStatus { tersimpan, menyimpan, offline, gagal }

abstract class SyncService {
  Stream<SyncServiceStatus> get statusStream;
  SyncServiceStatus get currentStatus;
  int get pendingChanges;
  DateTime? get lastSyncedAt;

  /// False while the background session (Auth/Supabase) is not ready yet.
  bool get canSync;
  Future<void> syncNow();
  void notifyForeground();
  void setConnection({required bool online});
  void clearLocalState();
  void recordLocalChange();
}

/// Status shared by every sync implementation: offline wins, then a running
/// cycle, then the last failure, then whether the outbox is empty.
SyncServiceStatus syncStatusFor({
  required bool online,
  required bool running,
  required bool failed,
  required int pending,
}) {
  if (!online) return SyncServiceStatus.offline;
  if (running) return SyncServiceStatus.menyimpan;
  if (failed) return SyncServiceStatus.gagal;
  return pending == 0 ? SyncServiceStatus.tersimpan : SyncServiceStatus.menyimpan;
}
