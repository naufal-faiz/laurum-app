import 'package:drift/drift.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/receipt_settings.dart';
import 'package:laurum/core/persistence/app_database.dart';

ReceiptSettings receiptFromRow(ReceiptSettingRow r) => ReceiptSettings(
  id: r.id,
  ownerId: r.ownerId,
  createdAt: r.createdAt,
  updatedAt: r.updatedAt,
  syncState: RecordSyncState.values.byName(r.syncState),
  paperMm: r.paperMm,
  fontSize: r.fontSize,
  showAddress: r.showAddress,
  showCustomer: r.showCustomer,
  showSavings: r.showSavings,
  showNote: r.showNote,
  deletedAt: r.deletedAt,
);
ReceiptSettingRecordsCompanion receiptToRow(ReceiptSettings r, DateTime at) =>
    ReceiptSettingRecordsCompanion.insert(
      id: r.id,
      ownerId: r.ownerId,
      createdAt: r.createdAt,
      updatedAt: Value(at),
      syncState: const Value('pending'),
      paperMm: Value(r.paperMm),
      fontSize: Value(r.fontSize),
      showAddress: Value(r.showAddress),
      showCustomer: Value(r.showCustomer),
      showSavings: Value(r.showSavings),
      showNote: Value(r.showNote),
      deletedAt: Value(r.deletedAt),
    );
Map<String, Object?> receiptPayload(ReceiptSettings r, DateTime at) => {
  'id': r.id,
  'owner_id': r.ownerId,
  'created_at': r.createdAt.toUtc().toIso8601String(),
  'updated_at': at.toUtc().toIso8601String(),
  'deleted_at': r.deletedAt?.toUtc().toIso8601String(),
  'paper_mm': r.paperMm,
  'font_size': r.fontSize,
  'show_address': r.showAddress,
  'show_customer': r.showCustomer,
  'show_savings': r.showSavings,
  'show_note': r.showNote,
};
