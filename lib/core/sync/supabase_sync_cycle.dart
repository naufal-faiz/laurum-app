import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_sync_cursor_store.dart';
import 'package:laurum/core/persistence/drift_sync_outbox_store.dart';
import 'package:laurum/core/persistence/drift_sync_remote_applier.dart';
import 'package:laurum/core/sync/supabase_sync_transport.dart';
import 'package:laurum/core/sync/sync_coordinator.dart';
import 'package:laurum/core/sync/sync_engine.dart';
import 'package:laurum/core/sync/sync_pull_runner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Gate factory for builds that already ran `initializeSupabase`. Keeping it
/// here means `main.dart` never imports a persistence package (aturan 19).
SyncCycle Function(AppDatabase, String) supabaseSyncCycleFromSession() =>
    (db, ownerId) => supabaseSyncCycle(db, Supabase.instance.client, ownerId);

/// One real push-then-pull pass for the active owner. The Supabase session in
/// [client] supplies the JWT, so RLS scopes every row to that account.
SyncCycle supabaseSyncCycle(AppDatabase db, SupabaseClient client, String ownerId) {
  final transport = SupabaseSyncTransport(client);
  return SyncCoordinator(
    SyncEngine(DriftSyncOutboxStore(db), transport),
    SyncPullRunner(transport, DriftSyncCursorStore(db), DriftSyncRemoteApplier(db, ownerId)),
  );
}
