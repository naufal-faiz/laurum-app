import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/core/domain/repositories/proposal_repository.dart';

void runProposalWeightContract(ProposalRepository Function() current) {
  test('estimated grams and unknown weight survive repository round trips and decisions', () async {
    final repo = current();
    for (final grams in <int?>[null, 2000]) {
      final p = Proposal(
        id: grams == null ? 'unknown-weight' : 'known-weight',
        ownerId: 'owner',
        createdAt: DateTime(2026),
        status: ProposalStatus.menunggu,
        sourceText: 'Synthetic request',
        estimatedWeightGrams: grams,
      );
      await repo.saveProposal(p);
      expect((await repo.getProposalById(p.id))!.estimatedWeightGrams, grams);
      final corrected = grams == null ? null : 3000;
      if (grams != null) {
        await repo.saveProposal(
          Proposal(
            id: p.id,
            ownerId: p.ownerId,
            createdAt: p.createdAt,
            status: p.status,
            sourceText: p.sourceText,
            estimatedWeightGrams: corrected,
          ),
        );
        expect((await repo.getProposalById(p.id))!.estimatedWeightGrams, corrected);
      }
      await repo.updateProposalStatus(p.id, ProposalStatus.disetujui, orderId: 'order');
      expect((await repo.getProposalById(p.id))!.estimatedWeightGrams, corrected);
    }
  });
}
