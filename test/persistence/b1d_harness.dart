import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/id_generator.dart';
import 'package:laurum/core/domain/service_item.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_local_settings_repository.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/core/services/fake_auth_service.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/features/business/data/drift_business_repository.dart';
import 'package:laurum/features/customers/data/drift_customer_repository.dart';
import 'package:laurum/features/customers/data/drift_savings_repository.dart';
import 'package:laurum/features/orders/data/drift_order_repository.dart';
import 'package:laurum/features/proposals/data/in_memory_proposal_repository.dart';
import 'package:laurum/features/services/data/drift_service_repository.dart';

import 'b1d_overrides.dart';

class B1dHarness {
  B1dHarness({this.proposalFactory});
  final InMemoryProposalRepository Function()? proposalFactory;
  final db = AppDatabase(NativeDatabase.memory());
  final ids = const IdGenerator();
  final at = DateTime(2026, 11, 4, 10, 0, 0, 123, 456);
  late final owner = ids.newId(), customerId = ids.newId(), serviceId = ids.newId();
  late final auth = FakeAuthService(userId: owner);
  final sync = FakeSyncService();
  late final runner = DriftTransactionRunner(
    db,
    participants: () => [
      scope.read(inMemoryProposalRepositoryProvider.notifier),
      auth,
      sync,
    ],
  );
  late final writer = OutboxWriter(db, runner, clock: () => at);
  late final customers = DriftCustomerRepository(db, owner, writer, clock: () => at);
  late final services = DriftServiceRepository(db, owner, writer, clock: () => at);
  late final business = DriftBusinessRepository(db, owner, writer, clock: () => at);
  late final orders = DriftOrderRepository(db, owner, writer, clock: () => at);
  late final savings = DriftSavingsRepository(db, owner, writer, clock: () => at);
  late final local = DriftLocalSettingsRepository(db);
  late final service = ServiceItem(
    id: serviceId,
    ownerId: owner,
    createdAt: at,
    name: 'Layanan uji',
    kind: ServiceKind.satuan,
    price: 1000,
    durationDays: 1,
  );
  late final scope = ProviderContainer(overrides: b1dOverrides(this));
  Future<void> seed() async {
    scope.read(inMemoryProposalRepositoryProvider.notifier).clearLocalData();
    await customers.saveCustomer(
      Customer(
        id: customerId,
        ownerId: owner,
        createdAt: at,
        name: 'Pelanggan uji',
        phone: '081234567890',
      ),
    );
    await services.saveService(service);
  }

  Future<Map<String, Object>> snapshot() async {
    final result = <String, Object>{};
    for (final t in db.allTables) {
      result[t.actualTableName] =
          (await db.customSelect('SELECT * FROM ${t.actualTableName} ORDER BY rowid').get())
              .map((r) => r.data)
              .toList();
    }
    return result;
  }

  Future<void> fail(String table, {String action = 'INSERT'}) => db.customStatement(
    "CREATE TEMP TRIGGER injected BEFORE $action ON $table BEGIN SELECT RAISE(ABORT, 'injected'); END",
  );
  Future<void> close() async {
    scope.dispose();
    sync.dispose();
    await db.close();
  }
}
