import 'package:laurum/core/persistence/account_local_data_service.dart';
import 'package:laurum/core/persistence/account_repositories.dart';
import 'package:laurum/core/persistence/device_registrar.dart';
import 'package:laurum/core/persistence/drift_change_monitor.dart';
import 'package:laurum/core/persistence/drift_sync_service.dart';
import 'package:laurum/core/sync/sync_coordinator.dart';

class AccountStore extends AccountRepositories {
  AccountStore(
    super.db,
    super.ownerId, {
    required super.directory,
    super.participants,
    super.clock,
    SyncCycle? cycle,
  }) : sync = DriftSyncService(db, cycle: cycle),
       _syncEnabled = cycle != null,
       changes = DriftChangeMonitor(db);
  final DriftSyncService sync;
  final DriftChangeMonitor changes;

  /// Without a real cycle (dummy mode) there is no server to register with.
  final bool _syncEnabled;
  late final DeviceRegistrar device = DeviceRegistrar(db, ownerId, writer);
  late final AccountLocalDataService localData;
  Future<void> start() async {
    await sync.start();
    changes.start();
    if (!_syncEnabled) return;
    try {
      await device.ensureRegistered();
    } catch (_) {
      /* A missing device row must never block opening the account. */
    }
  }

  Future<void> dispose() async {
    await changes.dispose();
    await sync.dispose();
  }
}
