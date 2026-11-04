import 'package:drift/native.dart';
import 'package:laurum/core/domain/business_profile.dart';
import 'package:laurum/core/domain/receipt_settings.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/features/business/data/drift_business_repository.dart';
import 'package:laurum/features/printer/data/drift_receipt_settings_repository.dart';
import 'package:laurum/features/services/data/drift_service_repository.dart';

class B1cHarness {
  B1cHarness() : db = AppDatabase(NativeDatabase.memory());
  final AppDatabase db;
  final at = DateTime.utc(2026, 11, 4, 8, 0, 0, 123, 456);
  late final writer = OutboxWriter(db, DriftTransactionRunner(db), clock: () => at);
  late final business = DriftBusinessRepository(db, 'owner', writer, clock: () => at);
  late final receipts = DriftReceiptSettingsRepository(db, 'owner', writer, clock: () => at);
  late final services = DriftServiceRepository(db, 'owner', writer, clock: () => at);
  BusinessProfile profile({String id = 'b', String owner = 'owner', bool enabled = true}) =>
      BusinessProfile(
        id: id,
        ownerId: owner,
        createdAt: at,
        name: 'Usaha',
        useOrderStatus: enabled,
      );
  ReceiptSettings settings({String id = 'r', String owner = 'owner', int paper = 80}) =>
      ReceiptSettings(id: id, ownerId: owner, createdAt: at, paperMm: paper);
  Future<void> failOutbox() => db.customStatement('''CREATE TRIGGER fail_outbox
    BEFORE INSERT ON outbox BEGIN SELECT RAISE(ABORT, 'injected'); END''');
}
