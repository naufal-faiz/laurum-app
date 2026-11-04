import 'package:flutter_riverpod/misc.dart';
import 'package:laurum/core/persistence/drift_local_data_service.dart';
import 'package:laurum/core/services/local_settings_providers.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/proposals/data/in_memory_proposal_repository.dart';
import 'package:laurum/features/shell/state/shell_state.dart';

import 'b1d_harness.dart';

List<Override> b1dOverrides(B1dHarness h) => [
  if (h.proposalFactory != null)
    inMemoryProposalRepositoryProvider.overrideWith(h.proposalFactory!),
  businessRepositoryProvider.overrideWithValue(h.business),
  receiptSettingsRepositoryProvider.overrideWithValue(h.business.receipts),
  customerRepositoryProvider.overrideWithValue(h.customers),
  serviceRepositoryProvider.overrideWithValue(h.services),
  orderRepositoryProvider.overrideWithValue(h.orders),
  savingsRepositoryProvider.overrideWithValue(h.savings),
  localSettingsRepositoryProvider.overrideWithValue(h.local),
  transactionRunnerProvider.overrideWithValue(h.runner),
  businessClockProvider.overrideWithValue(() => h.at),
  proposalRepositoryProvider.overrideWith(
    (ref) => ref.read(inMemoryProposalRepositoryProvider.notifier),
  ),
  authServiceProvider.overrideWithValue(h.auth),
  syncServiceProvider.overrideWithValue(h.sync),
  localDataServiceProvider.overrideWithValue(
    DriftLocalDataService(
      h.db,
      h.owner,
      h.runner,
      clearMemory: () async {
        h.scope.read(inMemoryProposalRepositoryProvider.notifier).clearLocalData();
        h.sync.clearLocalState();
      },
    ),
  ),
];
