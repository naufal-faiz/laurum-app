import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/savings_entry.dart';

import 'b1d_commands.dart';
import 'b1d_harness.dart';

void main() {
  test('order, items, payment and savings share one sync group', () async {
    final h = B1dHarness();
    addTearDown(h.close);
    await h.seed();
    await h.savings.addEntry(
      SavingsEntry(
        id: h.ids.newId(),
        ownerId: h.owner,
        createdAt: h.at,
        customerId: h.customerId,
        kind: SavingsKind.setor,
        amount: 1000,
        method: PayMethod.tunai,
      ),
    );
    await h.db.delete(h.db.outboxRecords).go();
    final id = await checkout(h, term: PayTerm.sekarang, received: 500, savings: true);
    expect(id, isNotNull);
    final rows = await (h.db.select(
      h.db.outboxRecords,
    )..orderBy([(t) => OrderingTerm(expression: t.groupSeq)])).get();
    expect(
      rows.map((r) => r.targetTable).toSet(),
      containsAll([
        'orders',
        'order_items',
        'payments',
        'savings_entries',
      ]),
    );
    expect(rows.map((r) => r.groupId).toSet(), hasLength(1));
    expect(rows.map((r) => r.groupSeq), [for (var i = 1; i <= rows.length; i++) i]);
  });
}
