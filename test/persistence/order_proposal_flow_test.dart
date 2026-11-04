import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/proposals/data/in_memory_proposal_repository.dart';
import 'package:laurum/features/proposals/state/proposal_actions.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';

import 'b1d_harness.dart';
import 'failing_b1d_proposal.dart';

void main() {
  for (final target in [
    'customers',
    'local_settings',
    'orders',
    'order_items',
    'outbox',
    'memory',
  ]) {
    test('approval rolls back $target and retry never duplicates order or counter', () async {
      final h = B1dHarness(proposalFactory: target == 'memory' ? FailingB1dProposal.new : null);
      addTearDown(h.close);
      await h.seed();
      final p = Proposal(
        id: h.ids.newId(),
        ownerId: h.owner,
        createdAt: h.at,
        status: ProposalStatus.menunggu,
        sourceText: 'Permintaan uji',
      );
      final repo = h.scope.read(proposalRepositoryProvider);
      await repo.saveProposal(p);
      final draft = ProposalDraft(
        name: 'Pelanggan AI',
        phone: '081298765432',
        address: 'Alamat uji',
        serviceId: h.serviceId,
      );
      final before = await h.snapshot();
      if (target != 'memory') await h.fail(target);
      final actions = h.scope.read(proposalActionsProvider(p.id).notifier);
      expect(await actions.approve(draft), isNull);
      expect(await h.snapshot(), before);
      expect((await repo.getProposalById(p.id))!.status, ProposalStatus.menunggu);
      if (target == 'memory') {
        (h.scope.read(
          inMemoryProposalRepositoryProvider.notifier,
        ) as FailingB1dProposal).allowApproval();
      } else {
        await h.db.customStatement('DROP TRIGGER injected');
      }
      final id = await actions.approve(draft);
      expect(id, h.ids.derived(p.id, 'order'));
      expect(await h.orders.getOrders(), hasLength(1));
      expect(await h.local.getInt('order_counter_A'), 1);
      final committed = await h.snapshot();
      expect(await actions.approve(draft), id);
      expect(await h.snapshot(), committed);
      // Simulate lost dummy approval state; the persisted proposal_id still prevents duplication.
      await repo.saveProposal(p);
      expect(await actions.approve(draft), id);
      expect(await h.snapshot(), committed);
    });
  }
}
