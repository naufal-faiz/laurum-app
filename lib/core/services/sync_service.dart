import 'dart:async';

enum SyncServiceStatus { tersimpan, menyimpan, offline, gagal }

abstract class SyncService {
  Stream<SyncServiceStatus> get statusStream;
  SyncServiceStatus get currentStatus;
  int get pendingChanges;
  DateTime? get lastSyncedAt;
  Future<void> syncNow();
  void clearLocalState();
  void recordLocalChange();
}

class FakeSyncService implements SyncService {
  FakeSyncService({
    SyncServiceStatus initialStatus = SyncServiceStatus.tersimpan,
    this.pendingChanges = 0,
    this.lastSyncedAt,
    this.succeeds = true,
    DateTime Function()? clock,
  }) : _currentStatus = initialStatus,
       _clock = clock ?? DateTime.now;

  final _controller = StreamController<SyncServiceStatus>.broadcast();
  SyncServiceStatus _currentStatus;
  int syncCallCount = 0;
  @override
  int pendingChanges;
  @override
  DateTime? lastSyncedAt;
  bool succeeds;
  final DateTime Function() _clock;

  @override
  Stream<SyncServiceStatus> get statusStream => _controller.stream;

  @override
  SyncServiceStatus get currentStatus => _currentStatus;

  void emitStatus(SyncServiceStatus status) {
    _currentStatus = status;
    _controller.add(status);
  }

  @override
  Future<void> syncNow() async {
    syncCallCount++;
    if (_currentStatus == SyncServiceStatus.offline) throw StateError('Offline');
    emitStatus(SyncServiceStatus.menyimpan);
    await Future<void>.delayed(Duration.zero);
    if (!succeeds) {
      emitStatus(SyncServiceStatus.gagal);
      throw StateError('Sync failed');
    }
    pendingChanges = 0;
    lastSyncedAt = _clock();
    emitStatus(SyncServiceStatus.tersimpan);
  }

  void dispose() {
    _controller.close();
  }

  @override
  void clearLocalState() {
    pendingChanges = 0;
    lastSyncedAt = null;
    emitStatus(SyncServiceStatus.tersimpan);
  }

  @override
  void recordLocalChange() {
    pendingChanges++;
    emitStatus(
      _currentStatus == SyncServiceStatus.offline || _currentStatus == SyncServiceStatus.gagal
          ? _currentStatus
          : SyncServiceStatus.menyimpan,
    );
  }
}
