import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/sql_timestamp.dart';

import 'b1d_harness.dart';

void main() {
  test('owner range/status and payment-parent queries use their indexes', () async {
    final h = B1dHarness();
    addTearDown(h.close);
    await h.seed();
    final samples = [
      (
        'SELECT * FROM orders WHERE owner_id = ? AND deleted_at IS NULL AND entered_at >= ? AND entered_at < ? ORDER BY rowid',
        [h.owner, sqlTimestamp(h.at), sqlTimestamp(h.at.add(const Duration(days: 1)))],
        'orders_owner_entered',
      ),
      (
        'SELECT * FROM orders WHERE owner_id = ? AND deleted_at IS NULL AND status = ? ORDER BY rowid',
        [h.owner, 'diproses'],
        'orders_owner_status',
      ),
      (
        'SELECT * FROM payments WHERE owner_id = ? AND deleted_at IS NULL AND order_id = ? ORDER BY rowid',
        [h.owner, h.ids.newId()],
        'payments_order',
      ),
    ];
    for (final (sql, values, index) in samples) {
      final rows = await h.db
          .customSelect(
            'EXPLAIN QUERY PLAN $sql',
            variables: values.map(Variable<String>.new).toList(),
          )
          .get();
      expect(rows.map((r) => r.read<String>('detail')).join('\n'), contains(index));
    }
  });
}
