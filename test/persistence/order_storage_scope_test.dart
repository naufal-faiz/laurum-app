import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/features/orders/data/drift_order_repository.dart';

import 'b1d_commands.dart';
import 'b1d_harness.dart';

void main() {
  late B1dHarness h;
  setUp(() async {
    h = B1dHarness();
    await h.seed();
  });
  tearDown(() => h.close());
  test('UUIDs, local metadata and snake_case wire payload cover all order tables', () async {
    final id = (await checkout(h, term: PayTerm.sekarang, received: 1000))!;
    final order = (await h.orders.getOrderById(id))!;
    final items = await h.orders.getItemsByOrderId(id);
    final payments = await h.orders.getPaymentsByOrderId(id);
    final events = await h.orders.getEventsByOrderId(id);
    final uuid = matches(
      RegExp(r'^[\da-f]{8}-[\da-f]{4}-4[\da-f]{3}-[89ab][\da-f]{3}-[\da-f]{12}$'),
    );
    for (final record in [order, ...items, ...payments, ...events]) {
      expect(record.id, uuid);
      expect(record.ownerId, h.owner);
      expect(record.updatedAt, h.at);
      expect(record.syncState, RecordSyncState.pending);
    }
    final outbox = await h.db.select(h.db.outboxRecords).get();
    final payloads = {
      for (final row in outbox) row.targetTable: jsonDecode(row.payload) as Map<String, dynamic>,
    };
    expect(payloads['orders']!['pay_term'], 'sekarang');
    expect(payloads['orders']!['status'], 'diproses');
    expect(payloads['orders']!.containsKey('pay_status'), isFalse);
    expect(payloads['order_items']!['service_name'], h.service.name);
    expect(payloads['order_items']!['qty_milli'], 1000);
    expect(payloads['payments']!['received'], 1000);
    expect(payloads['order_events']!['kind'], 'created');
    for (final payload in payloads.values) {
      expect(payload['owner_id'], h.owner);
      expect(payload['updated_at'], h.at.toUtc().toIso8601String());
      expect(payload.containsKey('sync_state'), isFalse);
    }
  });
  test(
    'removed items become synced tombstones and foreign accounts cannot read or write',
    () async {
      final id = (await checkout(h))!;
      final order = (await h.orders.getOrderById(id))!;
      final old = (await h.orders.getItemsByOrderId(id)).single;
      final replacement = OrderItem(
        id: h.ids.newId(),
        ownerId: h.owner,
        createdAt: h.at,
        orderId: id,
        serviceId: h.serviceId,
        serviceName: 'Snapshot baru',
        unit: 'pcs',
        qtyMilli: 1000,
        unitPrice: 1000,
        lineTotal: 1000,
      );
      await h.orders.saveOrder(order, items: [replacement]);
      expect((await h.orders.getItemsByOrderId(id)).single.id, replacement.id);
      final all = await h.db.select(h.db.orderItemRecords).get();
      expect(all.singleWhere((i) => i.id == old.id).deletedAt, h.at);
      final deleted = (await h.db.select(h.db.outboxRecords).get())
          .where((r) => r.rowId == old.id)
          .last;
      expect(
        (jsonDecode(deleted.payload) as Map<String, dynamic>)['deleted_at'],
        h.at.toUtc().toIso8601String(),
      );
      final foreign = DriftOrderRepository(h.db, h.ids.newId(), h.writer);
      expect(await foreign.getOrders(), isEmpty);
      expect(await foreign.getOrderById(id), isNull);
      expect(await foreign.getOrderByOrderNo(order.orderNo), isNull);
      expect(await foreign.getItemsByOrderId(id), isEmpty);
      expect(await foreign.getActiveOrders(), isEmpty);
      expect(await foreign.getActiveItems(), isEmpty);
      expect(await foreign.getActivePayments(), isEmpty);
      expect(await foreign.getPaymentsByOrderId(id), isEmpty);
      expect(await foreign.getEventsByOrderId(id), isEmpty);
      await expectLater(foreign.saveOrder(order), throwsStateError);
      await expectLater(foreign.updateOrderStatus(id, OrderStatus.siap), throwsStateError);
    },
  );
}
