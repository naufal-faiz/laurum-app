import 'dart:io';

import 'package:drift/native.dart';
import 'package:laurum/core/persistence/account_store.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/sync/supabase_sync_cycle.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const localSyncUrl = 'http://127.0.0.1:54321';
bool get localSyncAvailable =>
    Platform.environment['LAURUM_LOCAL_SUPABASE_URL'] == localSyncUrl &&
    (Platform.environment['LAURUM_LOCAL_PUBLIC_KEY']?.isNotEmpty ?? false) &&
    (Platform.environment['LAURUM_LOCAL_SERVICE_KEY']?.isNotEmpty ?? false);

class LocalAccountDevices {
  LocalAccountDevices(this.admin, this.clients, this.stores, this.owner);
  final SupabaseClient admin;
  final List<SupabaseClient> clients;
  final List<AccountStore> stores;
  final String owner;

  static Future<LocalAccountDevices> open() async {
    final env = Platform.environment;
    final admin = SupabaseClient(localSyncUrl, env['LAURUM_LOCAL_SERVICE_KEY']!);
    final suffix = DateTime.now().microsecondsSinceEpoch;
    final email = 'multidevice-$suffix@example.test';
    final password = 'Multidevice-$suffix!';
    final user = await admin.auth.admin.createUser(
      AdminUserAttributes(email: email, password: password, emailConfirm: true),
    );
    final clients = [
      for (var i = 0; i < 2; i++) SupabaseClient(localSyncUrl, env['LAURUM_LOCAL_PUBLIC_KEY']!),
    ];
    final stores = <AccountStore>[];
    for (final client in clients) {
      await client.auth.signInWithPassword(email: email, password: password);
      final db = AppDatabase(NativeDatabase.memory());
      stores.add(
        AccountStore(
          db,
          user.user!.id,
          directory: () async => Directory.systemTemp,
          cycle: supabaseSyncCycle(db, client, user.user!.id),
        ),
      );
    }
    return LocalAccountDevices(admin, clients, stores, user.user!.id);
  }

  Future<void> close() async {
    for (final store in stores) {
      await store.dispose();
      await store.db.close();
    }
    await clients.first.rpc<dynamic>('delete_my_account');
    await admin.auth.admin.deleteUser(owner);
    for (final client in clients) {
      await client.dispose();
    }
    await admin.dispose();
  }
}
