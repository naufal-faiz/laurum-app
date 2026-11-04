import 'package:drift/drift.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/savings_entry.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/sql_timestamp.dart';
import 'package:laurum/features/customers/data/savings_storage_mapping.dart';
import 'package:laurum/features/orders/data/order_item_storage.dart';
import 'package:laurum/features/orders/data/payment_storage.dart';

Future<List<Payment>> reportPayments(AppDatabase db, String owner, ReportRange range) async {
  final start = sqlTimestamp(range.start), end = sqlTimestamp(range.end);
  final rows = await db
      .customSelect(
        '''SELECT p.* FROM payments p
    WHERE p.owner_id = ? AND p.deleted_at IS NULL AND (
      (p.paid_at >= ? AND p.paid_at < ?) OR p.order_id IN (
        SELECT id FROM orders WHERE owner_id = ? AND deleted_at IS NULL
          AND status != 'dibatalkan' AND entered_at >= ? AND entered_at < ?
      )) ORDER BY p.rowid''',
        variables: [owner, start, end, owner, start, end].map(Variable<String>.new).toList(),
        readsFrom: {db.orderRecords, db.paymentRecords},
      )
      .get();
  return rows.map((r) => paymentFromRow(db.paymentRecords.map(r.data))).toList();
}

Future<List<SavingsEntry>> reportDeposits(AppDatabase db, String owner, ReportRange range) async {
  final rows = await db
      .customSelect(
        '''SELECT * FROM savings_entries WHERE owner_id = ?
    AND created_key >= ? AND created_key < ? AND kind = 'setor' AND method != 'tabungan'
    ORDER BY rowid''',
        variables: [
          owner,
          sqlTimestamp(range.start),
          sqlTimestamp(range.end),
        ].map(Variable<String>.new).toList(),
        readsFrom: {db.savingsRecords},
      )
      .get();
  return rows.map((r) => savingsFromRow(db.savingsRecords.map(r.data))).toList();
}

Future<List<OrderItem>> reportItems(AppDatabase db, String owner, ReportRange range) async {
  final rows = await db
      .customSelect(
        '''SELECT i.* FROM order_items i JOIN orders o ON o.id = i.order_id
    WHERE i.owner_id = ? AND o.owner_id = ? AND i.deleted_at IS NULL
      AND o.deleted_at IS NULL AND o.status != 'dibatalkan'
      AND o.entered_at >= ? AND o.entered_at < ? ORDER BY i.rowid''',
        variables: [
          owner,
          owner,
          sqlTimestamp(range.start),
          sqlTimestamp(range.end),
        ].map(Variable<String>.new).toList(),
        readsFrom: {db.orderRecords, db.orderItemRecords},
      )
      .get();
  return rows.map((r) => itemFromRow(db.orderItemRecords.map(r.data))).toList();
}
