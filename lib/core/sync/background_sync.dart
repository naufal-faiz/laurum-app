import 'package:laurum/core/persistence/app_database_factory.dart';
import 'package:laurum/core/persistence/supabase_bootstrap.dart';
import 'package:laurum/core/services/auth_config.dart';
import 'package:laurum/core/sync/supabase_sync_cycle.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';

/// Android/iOS background pass. It runs the same push-then-pull cycle as the
/// app, using the restored keystore session; signed-out installs do nothing.
const backgroundSyncTask = 'laurum.sync.periodic';

@pragma('vm:entry-point')
void backgroundSyncDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task != backgroundSyncTask) return true;
    final owner = await _sessionOwner();
    if (owner == null) return true;
    final directory = await getApplicationSupportDirectory();
    final factory = AppDatabaseFactory(owner, directory: () async => directory);
    try {
      final db = await factory.open();
      final result = await supabaseSyncCycle(db, Supabase.instance.client, owner).run();
      return result.succeeded;
    } catch (_) {
      return false; // Let WorkManager retry with its own backoff.
    } finally {
      await factory.close();
    }
  });
}

Future<String?> _sessionOwner() async {
  if (!await initializeSupabase(authConfigFromEnvironment)) return null;
  return Supabase.instance.client.auth.currentUser?.id;
}

Future<void> scheduleBackgroundSync() async {
  await Workmanager().initialize(backgroundSyncDispatcher);
  await Workmanager().registerPeriodicTask(
    backgroundSyncTask,
    backgroundSyncTask,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );
}
