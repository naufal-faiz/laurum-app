import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/account_setup_restore.dart';
import 'package:laurum/core/persistence/drift_repository_overrides.dart';
import 'package:laurum/core/persistence/drift_sync_remote_applier.dart';
import 'package:laurum/core/persistence/storage_providers.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/features/auth/state/auth_session.dart';

import '../drift_app_harness.dart';
import 'sync_wire_rows.dart';

void main() {
  test('a successful retry restores setup metadata without another login', () async {
    final app = await driftAppHarness(seed: false);
    final auth = FakeAuthService(userId: demoOwnerId, needsBusinessSetup: true);
    final scope = ProviderContainer(
      overrides: [
        ...driftRepositoryOverrides(auth: auth),
        accountStoreProvider.overrideWith((ref) async => app.store),
      ],
    );
    addTearDown(() async {
      scope.dispose();
      app.container.dispose();
      await app.store.dispose();
      await app.store.db.close();
    });
    scope.listen(accountSetupRestoreProvider, (_, _) {});
    await scope.read(accountSetupRestoreProvider.future);
    await pumpEventQueue();
    expect(auth.needsBusinessSetup, isTrue);
    await DriftSyncRemoteApplier(app.store.db, demoOwnerId).apply('businesses', [
      {...allWireRows().first, 'owner_id': demoOwnerId},
    ]);
    await pumpEventQueue();
    await scope.read(accountSetupRestoreProvider.future);
    expect(scope.read(authSessionProvider).needsSetup, isFalse);
    expect(scope.read(authSessionProvider).signedIn, isTrue);
    expect(auth.authActionLogs, isEmpty);
  });
}
