import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/core/services/id_generator_provider.dart';
import 'package:laurum/core/services/local_data_service.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/features/auth/data/auth_fixtures.dart';
import 'package:laurum/features/auth/data/dummy_account_data.dart';
import 'package:laurum/features/auth/data/dummy_transaction_runner.dart';
import 'package:laurum/features/business/data/business_fixtures.dart';
import 'package:laurum/features/customers/data/customer_history_offsets.dart';
import 'package:laurum/features/customers/state/customer_history_offsets.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/features/sync/data/sync_fixtures.dart';
import 'package:laurum/features/sync/state/sync_view.dart';

void notifyDummyWrite(Ref ref) {
  ref.read(syncServiceProvider).recordLocalChange();
  ref.invalidate(syncViewProvider);
  ref.notifyListeners();
}

List<Override> dummySessionOverrides({AuthService? authService, SyncService? syncService}) => [
  customerHistoryOffsetsProvider.overrideWithValue(memoryCustomerHistoryOffsets()),
  transactionRunnerProvider.overrideWith(dummyTransactionRunner),
  authServiceProvider.overrideWith(
    (ref) =>
        authService ??
        FakeAuthService(
          ids: ref.read(idGeneratorProvider),
          userId: dummyOwnerId,
          email: dummyGoogleEmail,
          accounts: dummyAuthAccounts(),
        ),
  ),
  localDataServiceProvider.overrideWith(
    (ref) => FakeLocalDataService(onDelete: () => clearDummyAccountData(ref)),
  ),
  syncServiceProvider.overrideWith((ref) {
    if (syncService != null) return syncService;
    final sync = FakeSyncService(
      lastSyncedAt: dummyLastSync,
      clock: ref.read(businessClockProvider),
    );
    ref.onDispose(sync.dispose);
    return sync;
  }),
];
