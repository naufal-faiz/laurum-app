import 'package:flutter_riverpod/misc.dart';
import 'package:laurum/core/persistence/drift_local_settings_repository.dart';
import 'package:laurum/core/persistence/storage_providers.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/core/services/dummy_history.dart';
import 'package:laurum/core/services/local_settings_providers.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/services/store_configuration.dart';
import 'package:laurum/features/auth/data/local_auth_service.dart';
import 'package:laurum/features/proposals/data/account_proposal_fixtures.dart';
import 'package:laurum/features/proposals/data/in_memory_proposal_repository.dart';
import 'package:laurum/features/shell/state/shell_state.dart';

List<Override> driftRepositoryOverrides({AuthService? auth, bool demoProposals = true}) => [
  storageGateEnabledProvider.overrideWithValue(true),
  authServiceProvider.overrideWith(
    (ref) => auth ?? localAuthService(demo: demoSeedEnabled, demoOwnerId: demoOwnerId),
  ),
  if (demoSeedEnabled)
    businessClockProvider.overrideWithValue(() => DateTime(2026, 10, 16, 10, 45)),
  businessRepositoryProvider.overrideWith((ref) => requireAccountStore(ref).business),
  receiptSettingsRepositoryProvider.overrideWith(
    (ref) => requireAccountStore(ref).business.receipts,
  ),
  customerRepositoryProvider.overrideWith((ref) => requireAccountStore(ref).customers),
  serviceRepositoryProvider.overrideWith((ref) => requireAccountStore(ref).services),
  orderRepositoryProvider.overrideWith((ref) => requireAccountStore(ref).orders),
  savingsRepositoryProvider.overrideWith((ref) => requireAccountStore(ref).savings),
  expenseRepositoryProvider.overrideWith((ref) => requireAccountStore(ref).expenses),
  reportRepositoryProvider.overrideWith((ref) => requireAccountStore(ref).reports),
  transactionRunnerProvider.overrideWith((ref) => requireAccountStore(ref, observe: false).runner),
  localSettingsRepositoryProvider.overrideWith(
    (ref) => DriftLocalSettingsRepository(requireAccountStore(ref, observe: false).db),
  ),
  localDataServiceProvider.overrideWith(
    (ref) => requireAccountStore(ref, observe: false).localData,
  ),
  syncServiceProvider.overrideWith((ref) => requireAccountStore(ref, observe: false).sync),
  proposalSeedProvider.overrideWith((ref) {
    final owner = ref.watch(activeOwnerProvider);
    return owner == demoOwnerId &&
            demoSeedEnabled &&
            demoProposals &&
            !ref.read(authServiceProvider).needsBusinessSetup
        ? accountProposalFixtures(owner!)
        : [];
  }),
  dummyHistoryEnabledProvider.overrideWith(
    (ref) =>
        demoSeedEnabled &&
        ref.watch(activeOwnerProvider) == demoOwnerId &&
        !ref.read(authServiceProvider).needsBusinessSetup,
  ),
  proposalRepositoryProvider.overrideWith((ref) {
    ref.watch(activeOwnerProvider);
    ref.listen(inMemoryProposalRepositoryProvider, (_, _) => ref.notifyListeners());
    return ref.read(inMemoryProposalRepositoryProvider.notifier);
  }),
];
