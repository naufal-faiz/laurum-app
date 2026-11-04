import 'package:laurum/core/domain/business_profile.dart';
import 'package:laurum/core/domain/id_generator.dart';
import 'package:laurum/core/domain/receipt_settings.dart';
import 'package:laurum/core/domain/repositories/business_repository.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/features/business/data/business_storage_mapping.dart';
import 'package:laurum/features/printer/data/drift_receipt_settings_repository.dart';

class DriftBusinessRepository implements BusinessRepository {
  DriftBusinessRepository(
    this.db,
    this.ownerId,
    this.writer, {
    this.ids = const IdGenerator(),
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now {
    if (!identical(db, writer.db)) throw ArgumentError('Outbox belongs to another database');
    receipts = DriftReceiptSettingsRepository(db, ownerId, writer, ids: ids, clock: this.clock);
  }
  final AppDatabase db;
  final String ownerId;
  final OutboxWriter writer;
  final IdGenerator ids;
  final DateTime Function() clock;
  late final DriftReceiptSettingsRepository receipts;
  late final _initial = BusinessProfile(
    id: ids.newId(),
    ownerId: ownerId,
    createdAt: clock(),
    name: '',
  );
  @override
  Future<BusinessProfile> getProfile() async {
    final row = await (db.select(
      db.businessRecords,
    )..where((r) => r.ownerId.equals(ownerId))).getSingleOrNull();
    return row == null ? _initial : businessFromRow(row);
  }

  @override
  Future<void> saveProfile(BusinessProfile profile) => writer.runner.run(() async {
    if (profile.ownerId != ownerId) throw StateError('Business belongs to another account');
    final table = db.businessRecords;
    final collision = await (db.select(
      table,
    )..where((r) => r.id.equals(profile.id))).getSingleOrNull();
    if (collision != null && collision.ownerId != ownerId) {
      throw StateError('Business belongs to another account');
    }
    final old = await (db.select(table)..where((r) => r.ownerId.equals(ownerId))).getSingleOrNull();
    if (old != null && old.id != profile.id) throw StateError('Business ID cannot change');
    final at = clock();
    await writer.write(
      table: 'businesses',
      rowId: profile.id,
      payload: businessPayload(profile, at),
      mutate: () async {
        await db.into(table).insertOnConflictUpdate(businessToRow(profile, at));
      },
    );
  });
  @override
  Future<ReceiptSettings> getReceiptSettings() => receipts.getReceiptSettings();
  @override
  Future<void> saveReceiptSettings(ReceiptSettings settings) =>
      receipts.saveReceiptSettings(settings);
}
