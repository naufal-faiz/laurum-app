import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/sync_bindings.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/core/sync/connection_monitor.dart';

class _FakeMonitor implements ConnectionMonitor {
  final _controller = StreamController<bool>.broadcast();
  bool disposed = false;
  bool get hasListener => _controller.hasListener;

  @override
  Stream<bool> get onlineChanges => _controller.stream;

  void emit({required bool online}) => _controller.add(online);

  @override
  void dispose() {
    disposed = true;
    unawaited(_controller.close());
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('bindings forward connectivity and stop after dispose', () async {
    final sync = FakeSyncService();
    addTearDown(sync.dispose);
    final monitor = _FakeMonitor();
    final container = ProviderContainer(
      overrides: [
        syncServiceProvider.overrideWithValue(sync),
        syncConnectionMonitorProvider.overrideWithValue(monitor),
      ],
    );
    final subscription = container.listen(syncBindingsProvider, (_, _) {});
    monitor.emit(online: false);
    await pumpEventQueue();
    expect(sync.currentStatus, SyncServiceStatus.offline);
    await expectLater(sync.syncNow(), throwsStateError);

    monitor.emit(online: true);
    await pumpEventQueue();
    expect(sync.currentStatus, SyncServiceStatus.tersimpan);
    expect(sync.canSync, isTrue);

    subscription.close();
    container.dispose();
    await pumpEventQueue();
    expect(monitor.hasListener, isFalse);
    monitor.emit(online: false);
    await pumpEventQueue();
    expect(sync.currentStatus, SyncServiceStatus.tersimpan);
  });
}
