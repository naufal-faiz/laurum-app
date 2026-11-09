import 'dart:async';

import 'package:laurum/core/domain/repositories/local_settings_repository.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_local_settings_repository.dart';
import 'package:laurum/core/persistence/sync_last_at_store.dart';
import 'package:laurum/core/persistence/sync_outbox_counter.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/core/sync/sync_coordinator.dart';
import 'package:laurum/core/sync/sync_trigger.dart';

// Outbox monitor plus the B2d trigger loop. Without a [SyncCycle] (Auth and
// Supabase are not initialised yet) it stays a pure local counter: no timers,
// no network, and syncNow only refreshes the pending count.
class DriftSyncService implements SyncService {
  DriftSyncService(
    AppDatabase db, {
    SyncCycle? cycle,
    DateTime Function()? clock,
    LocalSettingsRepository? settings,
  }) : _outbox = SyncOutboxCounter(db),
       _lastAt = SyncLastAtStore(settings ?? DriftLocalSettingsRepository(db)) {
    _trigger = SyncTrigger(
      cycle: cycle,
      clock: clock ?? DateTime.now,
      onChange: _emit,
      onSucceeded: _rememberLastSync,
    );
  }

  final SyncOutboxCounter _outbox;
  final SyncLastAtStore _lastAt;
  late final SyncTrigger _trigger;
  final _status = StreamController<SyncServiceStatus>.broadcast();
  StreamSubscription<int>? _subscription;
  int _pending = 0;
  DateTime? _lastSyncedAt;

  Future<void> start() async {
    _pending = await _outbox.count();
    _lastSyncedAt = await _lastAt.read();
    _subscription = _outbox.watch().listen(_setPending);
  }

  void _setPending(int count) {
    final grew = count > _pending;
    _pending = count;
    _emit();
    if (grew) _trigger.localChange();
  }

  Future<void> _rememberLastSync(DateTime at) async {
    _lastSyncedAt = at;
    await _lastAt.write(at);
    await refresh();
  }

  Future<void> refresh() async => _setPending(await _outbox.count());

  void _emit() {
    if (!_status.isClosed) _status.add(currentStatus);
  }

  @override
  bool get canSync => _trigger.canSync;
  @override
  int get pendingChanges => _pending;
  @override
  DateTime? get lastSyncedAt => _lastSyncedAt;
  @override
  SyncServiceStatus get currentStatus => syncStatusFor(
    online: _trigger.isOnline,
    running: _trigger.isRunning,
    failed: _trigger.isFailed,
    pending: _pending,
  );
  @override
  Stream<SyncServiceStatus> get statusStream => _status.stream;
  @override
  Future<void> syncNow() async {
    if (!_trigger.isOnline) throw StateError('Offline');
    if (!_trigger.canSync) return refresh();
    await _trigger.syncNow().whenComplete(_emit);
  }

  @override
  void notifyForeground() => _trigger.notifyForeground();
  @override
  void setConnection({required bool online}) => _trigger.setOnline(online: online);
  @override
  void recordLocalChange() {} // Writes already insert their own outbox row.

  @override
  void clearLocalState() {
    _lastSyncedAt = null;
    unawaited(_lastAt.clear());
    _emit();
  }

  Future<void> dispose() async {
    _trigger.dispose();
    await _subscription?.cancel();
    unawaited(_status.close()); // A paused listener must not block closing the DB.
  }
}
