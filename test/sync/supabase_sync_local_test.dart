import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/id_generator.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_sync_cursor_store.dart';
import 'package:laurum/core/persistence/drift_sync_outbox_store.dart';
import 'package:laurum/core/persistence/drift_sync_remote_applier.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/core/sync/supabase_sync_transport.dart';
import 'package:laurum/core/sync/sync_engine.dart';
import 'package:laurum/core/sync/sync_pull_result.dart';
import 'package:laurum/core/sync/sync_pull_runner.dart';
import 'package:laurum/core/sync/sync_run_result.dart';
import 'package:laurum/core/sync/sync_table_names.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _localUrl = 'http://127.0.0.1:54321';

void main() {
  final env = Platform.environment;
  final canRun =
      env['LAURUM_LOCAL_SUPABASE_URL'] == _localUrl &&
      (env['LAURUM_LOCAL_PUBLIC_KEY']?.isNotEmpty ?? false) &&
      (env['LAURUM_LOCAL_SERVICE_KEY']?.isNotEmpty ?? false);

  test('two local accounts push, pull and stay isolated across all tables', () async {
    final publicKey = env['LAURUM_LOCAL_PUBLIC_KEY']!;
    final serviceKey = env['LAURUM_LOCAL_SERVICE_KEY']!;
    final admin = SupabaseClient(_localUrl, serviceKey);
    final suffix = DateTime.now().microsecondsSinceEpoch;
    final password = 'b2c-$suffix-pass';
    final emailA = 'b2c-a-$suffix@example.test';
    final emailB = 'b2c-b-$suffix@example.test';
    final userA = await admin.auth.admin.createUser(
      AdminUserAttributes(email: emailA, password: password, emailConfirm: true),
    );
    final userB = await admin.auth.admin.createUser(
      AdminUserAttributes(email: emailB, password: password, emailConfirm: true),
    );
    final clientA = SupabaseClient(_localUrl, publicKey);
    final clientB = SupabaseClient(_localUrl, publicKey);
    final dbA = AppDatabase(NativeDatabase.memory());
    final dbB = AppDatabase(NativeDatabase.memory());
    final dbA2 = AppDatabase(NativeDatabase.memory());
    final dbB2 = AppDatabase(NativeDatabase.memory());
    try {
      await clientA.auth.signInWithPassword(email: emailA, password: password);
      await clientB.auth.signInWithPassword(email: emailB, password: password);
      final ownerA = clientA.auth.currentUser!.id;
      final ownerB = clientB.auth.currentUser!.id;
      const ids = IdGenerator();
      final at = DateTime.now().toUtc().toIso8601String();
      final business = ids.newId();
      final customer = ids.newId();
      final service = ids.newId();
      final category = ids.newId();
      final order = ids.newId();
      final item = ids.newId();
      final payment = ids.newId();
      final savings = ids.newId();
      final event = ids.newId();
      final expense = ids.newId();

      await _writeAll(
        dbA,
        ownerA,
        at,
        {
          'business': business,
          'customer': customer,
          'service': service,
          'category': category,
          'order': order,
          'item': item,
          'payment': payment,
          'savings': savings,
          'event': event,
          'expense': expense,
        },
      );
      final pushA = await SyncEngine(
        DriftSyncOutboxStore(dbA),
        SupabaseSyncTransport(clientA),
      ).run();
      expect(pushA.status, SyncRunStatus.selesai);
      expect(pushA.committedGroups, 1);

      final customerB = ids.newId();
      await _writeCustomer(dbB, ownerB, customerB, 'B Only', at);
      final pushB = await SyncEngine(
        DriftSyncOutboxStore(dbB),
        SupabaseSyncTransport(clientB),
      ).run();
      expect(pushB.status, SyncRunStatus.selesai);

      await admin.from('entitlements').insert({
        'id': ids.newId(),
        'owner_id': ownerA,
        'plan': 'pro',
        'source': 'b2c-local-test',
      });
      final pullA = await SyncPullRunner(
        SupabaseSyncTransport(clientA),
        DriftSyncCursorStore(dbA2),
        DriftSyncRemoteApplier(dbA2, ownerA),
      ).run();
      expect(pullA.status, SyncPullStatus.selesai);
      for (final table in syncPullOrder) {
        expect(await _count(dbA2, table), 1, reason: table);
      }
      final pulled = await dbA2.select(dbA2.customerRecords).getSingle();
      expect(pulled.id, customer);
      expect(pulled.name, 'Sari Wire');
      expect(pulled.nameKey, 'sari wire');
      expect(pulled.syncState, 'synced');
      final pulledOrder = await dbA2.select(dbA2.orderRecords).getSingle();
      expect(pulledOrder.total, 7000);

      final pullB = await SyncPullRunner(
        SupabaseSyncTransport(clientB),
        DriftSyncCursorStore(dbB2),
        DriftSyncRemoteApplier(dbB2, ownerB),
      ).run();
      expect(pullB.status, SyncPullStatus.selesai);
      expect(await _count(dbB2, 'customers'), 1);
      expect(await _count(dbB2, 'orders'), 0);
      expect((await dbB2.select(dbB2.customerRecords).getSingle()).name, 'B Only');
    } finally {
      for (final client in [clientA, clientB]) {
        try {
          await client.rpc<dynamic>('delete_my_account');
        } catch (_) {}
      }
      for (final id in [userA.user!.id, userB.user!.id]) {
        try {
          await admin.auth.admin.deleteUser(id);
        } catch (_) {}
      }
      await dbA.close();
      await dbB.close();
      await dbA2.close();
      await dbB2.close();
    }
  }, skip: canRun ? null : 'Set local Supabase env keys and start the stack');
}

Future<void> _writeAll(
  AppDatabase db,
  String owner,
  String at,
  Map<String, String> ids,
) async {
  final writer = OutboxWriter(db, DriftTransactionRunner(db));
  Future<void> put(String table, String rowId, Map<String, Object?> payload) =>
      writer.write(table: table, rowId: rowId, payload: payload, mutate: () async {});
  await writer.runner.run(() async {
    await put('businesses', ids['business']!, {
      'id': ids['business'],
      'owner_id': owner,
      'created_at': at,
      'name': 'B2c Laundry',
    });
    await put('customers', ids['customer']!, {
      'id': ids['customer'],
      'owner_id': owner,
      'created_at': at,
      'name': 'Sari Wire',
      'phone': '0812-3456',
    });
    await put('services', ids['service']!, {
      'id': ids['service'],
      'owner_id': owner,
      'created_at': at,
      'name': 'Cuci Kering',
      'kind': 'kiloan',
      'price': 7000,
      'duration_days': 2,
    });
    await put('expense_categories', ids['category']!, {
      'id': ids['category'],
      'owner_id': owner,
      'created_at': at,
      'name': 'Operasional',
    });
    await put('receipt_settings', '10000000-0000-4000-8000-000000000099', {
      'id': '10000000-0000-4000-8000-000000000099',
      'owner_id': owner,
      'created_at': at,
      'paper_mm': 80,
      'font_size': 12,
    });
    await put('devices', '10000000-0000-4000-8000-000000000098', {
      'id': '10000000-0000-4000-8000-000000000098',
      'owner_id': owner,
      'created_at': at,
      'code': 'B2C-DEV',
      'name': 'Local Test',
    });
    await put('orders', ids['order']!, {
      'id': ids['order'],
      'owner_id': owner,
      'created_at': at,
      'order_no': 'B2C-0001',
      'customer_id': ids['customer'],
      'status': 'diproses',
      'source': 'kasir',
      'pay_term': 'sekarang',
      'entered_at': at,
      'estimated_at': at,
      'subtotal': 7000,
      'total': 7000,
    });
    await put('order_items', ids['item']!, {
      'id': ids['item'],
      'owner_id': owner,
      'created_at': at,
      'order_id': ids['order'],
      'service_id': ids['service'],
      'service_name': 'Cuci Kering',
      'unit': 'kg',
      'qty_milli': 1000,
      'unit_price': 7000,
      'line_total': 7000,
    });
    await put('payments', ids['payment']!, {
      'id': ids['payment'],
      'owner_id': owner,
      'created_at': at,
      'order_id': ids['order'],
      'method': 'tunai',
      'amount': 7000,
      'received': 7000,
      'paid_at': at,
    });
    await put('savings_entries', ids['savings']!, {
      'id': ids['savings'],
      'owner_id': owner,
      'created_at': at,
      'customer_id': ids['customer'],
      'kind': 'setor',
      'amount': 5000,
      'method': 'tunai',
    });
    await put('order_events', ids['event']!, {
      'id': ids['event'],
      'owner_id': owner,
      'created_at': at,
      'order_id': ids['order'],
      'occurred_at': at,
      'kind': 'status',
      'to_status': 'diproses',
    });
    await put('expenses', ids['expense']!, {
      'id': ids['expense'],
      'owner_id': owner,
      'created_at': at,
      'category_id': ids['category'],
      'amount': 2000,
      'spent_at': at,
    });
  });
}

Future<void> _writeCustomer(
  AppDatabase db,
  String owner,
  String id,
  String name,
  String at,
) => OutboxWriter(db, DriftTransactionRunner(db)).write(
  table: 'customers',
  rowId: id,
  payload: {'id': id, 'owner_id': owner, 'created_at': at, 'name': name},
  mutate: () async {},
);

Future<int> _count(AppDatabase db, String table) async =>
    (await db.customSelect('SELECT COUNT(*) AS n FROM "$table"').getSingle()).read<int>('n');
