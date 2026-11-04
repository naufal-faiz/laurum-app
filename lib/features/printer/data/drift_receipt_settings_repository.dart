import 'package:laurum/core/domain/id_generator.dart';
import 'package:laurum/core/domain/receipt_settings.dart';
import 'package:laurum/core/domain/repositories/receipt_settings_repository.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/features/printer/data/receipt_storage_mapping.dart';

class DriftReceiptSettingsRepository implements ReceiptSettingsRepository {
  DriftReceiptSettingsRepository(
    this.db,
    this.ownerId,
    this.writer, {
    this.ids = const IdGenerator(),
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now {
    if (!identical(db, writer.db)) throw ArgumentError('Outbox belongs to another database');
  }
  final AppDatabase db;
  final String ownerId;
  final OutboxWriter writer;
  final IdGenerator ids;
  final DateTime Function() clock;
  late final _initial = ReceiptSettings(id: ids.newId(), ownerId: ownerId, createdAt: clock());
  @override
  Future<ReceiptSettings> getReceiptSettings() async {
    final row = await (db.select(
      db.receiptSettingRecords,
    )..where((r) => r.ownerId.equals(ownerId))).getSingleOrNull();
    return row == null ? _initial : receiptFromRow(row);
  }

  @override
  Future<void> saveReceiptSettings(ReceiptSettings settings) => writer.runner.run(() async {
    if (settings.ownerId != ownerId) throw StateError('Receipt settings belong to another account');
    final table = db.receiptSettingRecords;
    final collision = await (db.select(
      table,
    )..where((r) => r.id.equals(settings.id))).getSingleOrNull();
    if (collision != null && collision.ownerId != ownerId) {
      throw StateError('Receipt settings belong to another account');
    }
    final old = await (db.select(table)..where((r) => r.ownerId.equals(ownerId))).getSingleOrNull();
    if (old != null && old.id != settings.id) throw StateError('Receipt settings ID cannot change');
    final at = clock();
    await writer.write(
      table: 'receipt_settings',
      rowId: settings.id,
      payload: receiptPayload(settings, at),
      mutate: () async {
        await db.into(table).insertOnConflictUpdate(receiptToRow(settings, at));
      },
    );
  });
}
