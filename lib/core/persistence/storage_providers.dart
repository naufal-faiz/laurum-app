import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/persistence/account_storage.dart';
import 'package:laurum/core/persistence/account_store.dart';
import 'package:laurum/core/persistence/demo_fixture_id.dart';
import 'package:laurum/core/persistence/demo_seeder.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/services/store_configuration.dart';
import 'package:laurum/core/services/transaction_runner.dart';
import 'package:laurum/features/auth/data/reset_account_drafts.dart';
import 'package:laurum/features/auth/state/account_identity.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/features/proposals/data/in_memory_proposal_repository.dart';
import 'package:laurum/features/shell/state/shell_state.dart';

final storageGateEnabledProvider = Provider<bool>((ref) => false);
final demoOwnerId = demoFixtureId('laurum-demo', 'owner-001');
final accountStorageProvider = Provider<AccountStorage>((ref) {
  final manager = AccountStorage(
    clock: ref.read(businessClockProvider),
    participants: () => [
      ref.read(authServiceProvider) as TransactionParticipant,
      ref.read(inMemoryProposalRepositoryProvider.notifier),
    ],
    prepare: (store) async {
      if (demoSeedEnabled &&
          store.ownerId == demoOwnerId &&
          !ref.read(authServiceProvider).needsBusinessSetup) {
        await DemoSeeder(store.db, store.ownerId, store.writer).run();
      }
    },
  );
  ref.onDispose(() => unawaited(manager.close()));
  return manager;
});
final activeOwnerProvider = Provider<String?>((ref) => ref.watch(accountIdentityProvider));
final accountStoreProvider = FutureProvider<AccountStore?>((ref) async {
  final owner = ref.watch(activeOwnerProvider);
  resetAccountDrafts(ref);
  final store = await ref.read(accountStorageProvider).activate(owner);
  if (!ref.mounted) return null;
  final auth = ref.read(authServiceProvider);
  if (store != null && auth.needsBusinessSetup) {
    final profile = await store.business.getProfile();
    if (!ref.mounted || auth.currentUserId != owner) return null;
    if (profile.name.isNotEmpty) {
      await auth.completeBusinessSetup();
      ref.invalidate(authSessionProvider);
    }
  }
  return store;
});
final accountChangesProvider = StreamProvider<int>((ref) async* {
  final store = await ref.watch(accountStoreProvider.future);
  if (store == null) return;
  yield* store.changes.stream;
});
AccountStore requireAccountStore(Ref ref, {bool observe = true}) {
  final store = ref.watch(accountStoreProvider).requireValue;
  if (store == null) throw StateError('Account database is not open');
  if (observe) ref.listen(accountChangesProvider, (_, _) => ref.notifyListeners());
  return store;
}
