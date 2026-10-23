import 'dart:async';

enum SyncServiceStatus { tersimpan, menyimpan, offline, gagal }

abstract class SyncService {
  Stream<SyncServiceStatus> get statusStream;
  SyncServiceStatus get currentStatus;
  Future<void> syncNow();
}

class FakeSyncService implements SyncService {
  FakeSyncService({
    SyncServiceStatus initialStatus = SyncServiceStatus.tersimpan,
  }) : _currentStatus = initialStatus;

  final _controller = StreamController<SyncServiceStatus>.broadcast();
  SyncServiceStatus _currentStatus;
  int syncCallCount = 0;

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
    emitStatus(SyncServiceStatus.menyimpan);
    await Future<void>.delayed(Duration.zero);
    emitStatus(SyncServiceStatus.tersimpan);
  }

  void dispose() {
    _controller.close();
  }
}
