import 'dart:async';

/// Emits the device connectivity as booleans, starting with the current value.
/// Sync stays idle while the stream says offline.
abstract interface class ConnectionMonitor {
  Stream<bool> get onlineChanges;
  void dispose();
}

/// No connectivity information: stays silent so the service keeps its default
/// online state. Used by tests, dummy data, and before the plugin is wired.
class NoopConnectionMonitor implements ConnectionMonitor {
  const NoopConnectionMonitor();

  @override
  Stream<bool> get onlineChanges => const Stream<bool>.empty();

  @override
  void dispose() {}
}
