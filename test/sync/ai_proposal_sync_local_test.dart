import 'dart:io';

import 'package:drift/drift.dart';
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
import 'package:supabase_flutter/supabase_flutter.dart';

const _localUrl = 'http://127.0.0.1:54321';

void main() {
  final env = Platform.environment;
  final canRun =
      env['LAURUM_LOCAL_SUPABASE_URL'] == _localUrl &&
      (env['LAURUM_LOCAL_PUBLIC_KEY']?.isNotEmpty ?? false) &&
      (env['LAURUM_LOCAL_SERVICE_KEY']?.isNotEmpty ?? false);

  test('an owner decision on an AI proposal keeps fractional confidence', () async {
    final admin = SupabaseClient(_localUrl, env['LAURUM_LOCAL_SERVICE_KEY']!);
    final suffix = DateTime.now().microsecondsSinceEpoch;
    final email = 'b7c-$suffix@example.test';
    final password = 'b7c-$suffix-pass';
    final user = await admin.auth.admin.createUser(
      AdminUserAttributes(email: email, password: password, emailConfirm: true),
    );
    final client = SupabaseClient(_localUrl, env['LAURUM_LOCAL_PUBLIC_KEY']!);
    final db = AppDatabase(NativeDatabase.memory());
    try {
      await client.auth.signInWithPassword(email: email, password: password);
      final owner = client.auth.currentUser!.id;
      final id = const IdGenerator().newId();
      final at = DateTime.now().toUtc().toIso8601String();
      await admin.from('ai_proposals').insert({
        'id': id,
        'owner_id': owner,
        'status': 'menunggu',
        'source_text': 'cuci 2 kg',
        'customer_name': 'Sari',
        'phone': '081234567890',
        'address': 'Jl. Mawar 1',
        'wa_message_id': 'wamid-$suffix',
        'chat_id': 'chat-$suffix',
        'confidence': 0.9,
        'received_at': at,
      });
      final pulled = await SyncPullRunner(
        SupabaseSyncTransport(client),
        DriftSyncCursorStore(db),
        DriftSyncRemoteApplier(db, owner),
      ).run();
      expect(pulled.status, SyncPullStatus.selesai);
      final row = (await db.select(db.aiProposalRecords).getSingle());
      expect(row.confidence, 0.9);

      final writer = OutboxWriter(db, DriftTransactionRunner(db));
      final payload = {
        'id': row.id,
        'owner_id': row.ownerId,
        'created_at': row.createdAt.toUtc().toIso8601String(),
        'updated_at': at,
        'deleted_at': null,
        'status': 'disetujui',
        'source_text': row.sourceText,
        'customer_name': row.customerName,
        'phone': row.phone,
        'address': row.address,
        'service_id': row.serviceId,
        'customer_id': row.customerId,
        'order_id': row.orderId,
        'cancel_requested': row.cancelRequested,
        'uncertain_address': row.uncertainAddress,
        'wa_message_id': row.waMessageId,
        'chat_id': row.chatId,
        'confidence': row.confidence,
        'received_at': row.receivedAt?.toUtc().toIso8601String(),
      };
      await writer.write(
        table: 'ai_proposals',
        rowId: row.id,
        payload: payload,
        mutate: () =>
            (db.update(
              db.aiProposalRecords,
            )..where((r) => r.id.equals(row.id))).write(
              const AiProposalRecordsCompanion(
                status: Value('disetujui'),
                syncState: Value('pending'),
              ),
            ),
      );
      final push = await SyncEngine(
        DriftSyncOutboxStore(db),
        SupabaseSyncTransport(client),
      ).run();
      expect(push.status, SyncRunStatus.selesai);
      final server = await admin
          .from('ai_proposals')
          .select('status, confidence')
          .eq('id', id)
          .single();
      expect(server['status'], 'disetujui');
      expect((server['confidence'] as num).toDouble(), 0.9);
    } finally {
      try {
        await client.rpc<dynamic>('delete_my_account');
      } catch (_) {}
      try {
        await admin.auth.admin.deleteUser(user.user!.id);
      } catch (_) {}
      await db.close();
    }
  }, skip: canRun ? null : 'Set local Supabase env keys and start the stack');
}
