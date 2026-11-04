import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/features/business/data/drift_business_repository.dart';
import 'package:laurum/features/business/data/in_memory_business_repository.dart';
import 'package:laurum/features/printer/data/drift_receipt_settings_repository.dart';
import 'package:laurum/features/printer/data/in_memory_receipt_settings_repository.dart';
import 'package:laurum/features/services/data/drift_service_repository.dart';

import '../contracts/business_contract.dart';
import '../contracts/receipt_settings_contract.dart';
import '../contracts/service_contract.dart';

void main() {
  late AppDatabase db;
  late OutboxWriter writer;
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    writer = OutboxWriter(db, DriftTransactionRunner(db));
  });
  tearDown(() => db.close());
  group(
    'Drift Business contract',
    () => runBusinessRepositoryContract(
      () => DriftBusinessRepository(db, 'owner', writer),
    ),
  );
  group(
    'Drift Service contract',
    () => runServiceRepositoryContract(
      () => DriftServiceRepository(db, 'owner', writer),
    ),
  );
  group(
    'Drift Receipt contract',
    () => runReceiptSettingsRepositoryContract(
      () => DriftReceiptSettingsRepository(db, 'owner', writer),
    ),
  );
  group('InMemory Receipt contract', () {
    late ProviderContainer scope;
    setUp(() => scope = ProviderContainer());
    tearDown(() => scope.dispose());
    runReceiptSettingsRepositoryContract(
      () => InMemoryReceiptSettingsRepository(
        scope.read(inMemoryBusinessRepositoryProvider.notifier),
      ),
    );
  });
}
