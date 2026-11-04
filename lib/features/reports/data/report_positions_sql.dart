import 'package:drift/drift.dart';
import 'package:laurum/core/domain/report_positions.dart';
import 'package:laurum/core/persistence/app_database.dart';

Future<ReportPositions> readReportPositions(AppDatabase db, String owner) async {
  final due = await db
      .customSelect(
        '''SELECT COALESCE(SUM(due), 0) AS outstanding,
    COALESCE(SUM(CASE WHEN due > 0 THEN 1 ELSE 0 END), 0) AS unpaid_count FROM (
      SELECT MIN(o.total, MAX(0, o.total - COALESCE(p.paid, 0))) AS due
      FROM orders o LEFT JOIN (
        SELECT order_id, SUM(amount) AS paid FROM payments
        WHERE owner_id = ? AND deleted_at IS NULL GROUP BY order_id
      ) p ON p.order_id = o.id
      WHERE o.owner_id = ? AND o.deleted_at IS NULL AND o.status != 'dibatalkan'
    )''',
        variables: [Variable<String>(owner), Variable<String>(owner)],
        readsFrom: {db.orderRecords, db.paymentRecords},
      )
      .getSingle();
  final savings = await db
      .customSelect(
        '''SELECT COALESCE(SUM(
    CASE WHEN kind = 'pakai' THEN -amount ELSE amount END), 0) AS balance
    FROM savings_entries WHERE owner_id = ?''',
        variables: [Variable<String>(owner)],
        readsFrom: {db.savingsRecords},
      )
      .getSingle();
  return ReportPositions(
    outstanding: due.read<int>('outstanding'),
    unpaidCount: due.read<int>('unpaid_count'),
    savings: savings.read<int>('balance'),
  );
}
