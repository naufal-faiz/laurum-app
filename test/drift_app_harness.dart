import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/app.dart';
import 'package:laurum/core/persistence/account_local_data_service.dart';
import 'package:laurum/core/persistence/account_store.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/demo_seeder.dart';
import 'package:laurum/core/persistence/drift_local_data_service.dart';
import 'package:laurum/core/persistence/drift_repository_overrides.dart';
import 'package:laurum/core/persistence/storage_providers.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/core/services/transaction_runner.dart';
import 'package:laurum/features/proposals/data/in_memory_proposal_repository.dart';

Future<({ProviderContainer container, AccountStore store})> driftAppHarness({
  bool seed = true,
}) async {
  final db = AppDatabase(NativeDatabase.memory());
  final auth = FakeAuthService(userId: demoOwnerId);
  late ProviderContainer container;
  final store = AccountStore(
    db,
    demoOwnerId,
    directory: () async => Directory.systemTemp,
    clock: () => DateTime(2026, 10, 16, 10, 45),
    participants: () => [
      auth as TransactionParticipant,
      container.read(inMemoryProposalRepositoryProvider.notifier),
    ],
  );
  store.localData = AccountLocalDataService(
    DriftLocalDataService(db, demoOwnerId, store.runner),
    () async {},
  );
  container = ProviderContainer(
    overrides: [
      ...driftRepositoryOverrides(auth: auth, demoProposals: seed),
      accountStoreProvider.overrideWith((ref) async => store),
    ],
  );
  if (seed) await DemoSeeder(db, demoOwnerId, store.writer).run();
  await store.start();
  await container.read(accountStoreProvider.future);
  return (container: container, store: store);
}

Future<void> pumpDriftApp(WidgetTester tester, ProviderContainer container, GoRouter router) =>
    tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: LaurumApp(router: router),
      ),
    );
