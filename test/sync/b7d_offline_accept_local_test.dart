import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/id_generator.dart';
import 'package:laurum/core/domain/order.dart';

import 'local_account_devices.dart';

void main() {
  test('offline acceptance survives AI withdrawal and refreshes server metadata', () async {
    final h = await LocalAccountDevices.open();
    addTearDown(h.close);
    final a = h.stores.first;
    final at = DateTime.now().toUtc();
    const ids = IdGenerator();
    final instance = ids.newId();
    await h.admin.from('wa_connections').insert({
      'id': ids.newId(),
      'owner_id': h.owner,
      'instance_id': instance,
      'status': 'terhubung',
      'connected_at': at.subtract(const Duration(hours: 1)).toIso8601String(),
    });
    Future<void> ingest(String action, double confidence) async {
      final result = await h.admin.rpc<Map<String, dynamic>>(
        'ingest_ai_proposal',
        params: {
          'p_instance_id': instance,
          'p_wa_message_id': ids.newId(),
          'p_chat_id': '6281200000001@s.whatsapp.net',
          'p_received_at': DateTime.now().toUtc().toIso8601String(),
          'p_payload': {
            'action': action,
            'phone': '6281200000001',
            'source_text': 'Fixture order',
            'draft_context': {'confidence': confidence},
          },
        },
      );
      expect(result['code'], isIn(['created', 'updated', 'closed']));
    }

    await ingest('order', 0.7);
    await a.sync.syncNow();
    final proposal = (await a.proposals.getProposals()).single;
    expect((await a.db.select(a.db.aiProposalRecords).getSingle()).confidence, 0.7);
    await ingest('order', 0.9);
    await ingest('cancel', 0.9);
    final orderId = ids.derived(proposal.id, 'order');
    final customerId = ids.newId();
    await a.runner.run(() async {
      await a.customers.saveCustomer(
        Customer(
          id: customerId,
          ownerId: h.owner,
          createdAt: at,
          name: 'Fixture customer',
        ),
      );
      await a.orders.saveOrder(
        Order(
          id: orderId,
          ownerId: h.owner,
          createdAt: at,
          orderNo: 'A-0001',
          customerId: customerId,
          proposalId: proposal.id,
          status: OrderStatus.diproses,
          source: OrderSource.whatsappAi,
          discount: 0,
          enteredAt: at,
          estimatedAt: at,
          subtotal: 0,
          total: 0,
        ),
      );
      await a.proposals.saveProposal(
        proposal.withStatus(ProposalStatus.disetujui, orderId: orderId),
      );
    });
    await a.sync.syncNow();
    expect(await a.db.select(a.db.outboxRecords).get(), isEmpty);
    final row = await a.db.select(a.db.aiProposalRecords).getSingle();
    expect(row.status, 'disetujui');
    expect(row.confidence, 0.9);
    final remote = await h.admin
        .from('ai_proposals')
        .select('status,order_id')
        .eq('id', proposal.id)
        .single();
    expect(remote, {'status': 'disetujui', 'order_id': orderId});
    expect(await h.admin.from('orders').select('id').eq('id', orderId), hasLength(1));
  }, skip: localSyncAvailable ? null : 'Start local Supabase and set local test keys');
}
