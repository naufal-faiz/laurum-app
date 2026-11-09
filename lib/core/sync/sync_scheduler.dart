import 'dart:async';

import 'package:laurum/core/sync/sync_timing.dart';

/// Serialises sync triggers, debounces writes, retries with backoff, and stays
/// idle while offline, resuming when connectivity returns.
class SyncScheduler {
  SyncScheduler({
    required this.run,
    this.debounce = syncDebounce,
    this.periodicInterval = syncPeriodic,
  });
  final Future<void> Function() run;
  final Duration debounce;
  final Duration periodicInterval;
  Timer? _timer;
  Timer? _periodic;
  bool _online = true;
  bool _running = false;
  bool _waiting = false;
  bool _disposed = false;
  int _attempt = 0;

  /// A burst of local writes becomes one cycle after [debounce].
  void localChange() => _schedule(debounce);

  /// Login, foreground, manual, and periodic triggers run right away.
  void immediate() {
    if (_disposed || !_online) return;
    if (_running) {
      _waiting = true;
      return;
    }
    _timer?.cancel();
    unawaited(_fire());
  }

  /// Going offline cancels pending work; coming back runs right away.
  void setOnline({required bool online}) {
    if (_online == online) return;
    _online = online;
    if (online) {
      immediate();
      return;
    }
    _timer?.cancel();
    _waiting = false;
  }

  void startPeriodic() {
    if (_disposed || _periodic != null) return;
    _periodic = Timer.periodic(periodicInterval, (_) => immediate());
  }

  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _periodic?.cancel();
  }

  /// Runs now and completes after the cycle. Failures are rethrown for manual
  /// sync, while backoff still schedules the retry.
  Future<void> triggerNow() async {
    if (_disposed) return;
    if (!_online) throw StateError('Offline');
    if (_running) {
      _waiting = true;
      return;
    }
    _timer?.cancel();
    await _fire(throwOnError: true);
  }

  void _schedule(Duration delay) {
    if (_disposed || !_online) return;
    if (_running) {
      _waiting = true;
      return;
    }
    _timer?.cancel();
    _timer = Timer(delay, () => unawaited(_fire()));
  }

  Future<void> _fire({bool throwOnError = false}) async {
    if (_disposed || !_online || _running) return;
    _timer?.cancel();
    _running = true;
    (Object, StackTrace)? failure;
    try {
      await run();
      _attempt = 0;
    } catch (error, stack) {
      failure = (error, stack);
    }
    _running = false;
    if (_disposed) return;
    if (failure != null) {
      _waiting = false;
      if (_online) _schedule(syncRetryDelay(++_attempt));
      if (throwOnError) Error.throwWithStackTrace(failure.$1, failure.$2);
      return;
    }
    if (_waiting) {
      _waiting = false;
      _schedule(debounce);
    }
  }
}
