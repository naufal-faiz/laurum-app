import 'package:laurum/core/sync/sync_coordinator.dart';
import 'package:laurum/core/sync/sync_scheduler.dart';

/// Drives [SyncCycle]s from the B2d triggers and exposes the run state.
///
/// Without a cycle (Auth and Supabase are not initialised yet) it stays idle:
/// no timers, no network. Failures retry with backoff via [SyncScheduler].
class SyncTrigger {
  SyncTrigger({
    required SyncCycle? cycle,
    this.onChange,
    this.onSucceeded,
    DateTime Function()? clock,
  }) : _cycle = cycle,
       _clock = clock ?? DateTime.now {
    _scheduler = SyncScheduler(run: _run);
    if (cycle != null) _scheduler.startPeriodic();
  }

  final SyncCycle? _cycle;
  final void Function()? onChange;
  final Future<void> Function(DateTime at)? onSucceeded;
  final DateTime Function() _clock;
  late final SyncScheduler _scheduler;
  bool _online = true;
  bool _running = false;
  bool _failed = false;

  bool get isOnline => _online;
  bool get isRunning => _running;
  bool get isFailed => _failed;
  bool get canSync => _cycle != null && _online;

  void localChange() {
    if (canSync) _scheduler.localChange();
  }

  void notifyForeground() {
    if (canSync) _scheduler.immediate();
  }

  void setOnline({required bool online}) {
    if (_online == online) return;
    _online = online;
    _scheduler.setOnline(online: online);
    onChange?.call();
  }

  Future<void> syncNow() async {
    if (canSync) await _scheduler.triggerNow();
  }

  Future<void> _run() async {
    final cycle = _cycle;
    if (cycle == null) return;
    _running = true;
    _failed = false;
    onChange?.call();
    try {
      final result = await cycle.run();
      if (!result.succeeded) throw StateError('Sync cycle did not finish');
      await onSucceeded?.call(_clock());
    } catch (_) {
      _failed = true;
      rethrow;
    } finally {
      _running = false;
      onChange?.call();
    }
  }

  void dispose() => _scheduler.dispose();
}
