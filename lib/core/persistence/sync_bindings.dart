import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:laurum/core/persistence/storage_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/sync/connection_monitor.dart';
import 'package:laurum/core/sync/connectivity_connection_monitor.dart';

final syncConnectionMonitorProvider = Provider<ConnectionMonitor>((ref) {
  const monitor = NoopConnectionMonitor();
  ref.onDispose(monitor.dispose);
  return monitor;
});

/// Wires connectivity and app lifecycle into the active sync service. The app
/// root watches it; nothing starts until the account store is ready.
final syncBindingsProvider = Provider<void>((ref) {
  if (ref.watch(storageGateEnabledProvider)) {
    final store = ref.watch(accountStoreProvider);
    if (!store.hasValue || store.value == null) return;
  }
  final service = ref.watch(syncServiceProvider);
  final monitor = ref.watch(syncConnectionMonitorProvider);
  final subscription = monitor.onlineChanges.listen(
    (online) => service.setConnection(online: online),
  );
  final lifecycle = AppLifecycleListener(onResume: service.notifyForeground);
  ref.onDispose(() {
    unawaited(subscription.cancel());
    lifecycle.dispose();
  });
});

/// Real radio status for the running app; tests keep the noop default.
Override realConnectionMonitor() => syncConnectionMonitorProvider.overrideWith((ref) {
  final monitor = ConnectivityConnectionMonitor();
  ref.onDispose(monitor.dispose);
  return monitor;
});
