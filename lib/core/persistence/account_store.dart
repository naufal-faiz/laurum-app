import 'package:laurum/core/persistence/account_local_data_service.dart';
import 'package:laurum/core/persistence/account_repositories.dart';
import 'package:laurum/core/persistence/drift_change_monitor.dart';
import 'package:laurum/core/persistence/drift_sync_service.dart';

class AccountStore extends AccountRepositories {
  AccountStore(
    super.db,
    super.ownerId, {
    required super.directory,
    super.participants,
    super.clock,
  }) : sync = DriftSyncService(db),
       changes = DriftChangeMonitor(db);
  final DriftSyncService sync;
  final DriftChangeMonitor changes;
  late final AccountLocalDataService localData;
  Future<void> start() async {
    await sync.start();
    changes.start();
  }

  Future<void> dispose() async {
    await changes.dispose();
    await sync.dispose();
  }
}
