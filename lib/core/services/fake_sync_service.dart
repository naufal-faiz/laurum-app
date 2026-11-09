import 'dart:async';

import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/core/services/transaction_runner.dart';

class FakeSyncService implements SyncService, TransactionParticipant {
  @override
  void Function() checkpoint() {
    final pending = pendingChanges, last = lastSyncedAt, status = _currentStatus;
    return () {
      pendingChanges = pending;
      lastSyncedAt = last;
      emitStatus(status);
    };
  }

  FakeSyncService({
    SyncServiceStatus initialStatus = SyncServiceStatus.tersimpan,
    this.pendingChanges = 0,
    this.lastSyncedAt,
    this.succeeds = true,
    DateTime Function()? clock,
  }) : _currentStatus = initialStatus,
       _online = initialStatus != SyncServiceStatus.offline,
       _clock = clock ?? DateTime.now;

  final _controller = StreamController<SyncServiceStatus>.broadcast();
  SyncServiceStatus _currentStatus;
  bool _online;
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
  @override
  bool get canSync => true;

  void emitStatus(SyncServiceStatus status) {
    _currentStatus = status;
    _controller.add(status);
  }

  @override
  Future<void> syncNow() async {
    syncCallCount++;
    if (!_online) throw StateError('Offline');
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
  void notifyForeground() {
    if (_online) unawaited(syncNow().catchError((_) {}));
  }

  @override
  void setConnection({required bool online}) {
    if (_online == online) return;
    _online = online;
    if (!online) {
      emitStatus(SyncServiceStatus.offline);
      return;
    }
    emitStatus(
      pendingChanges == 0 ? SyncServiceStatus.tersimpan : SyncServiceStatus.menyimpan,
    );
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
