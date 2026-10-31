import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/proposals/data/in_memory_proposal_repository.dart';
import 'package:laurum/features/proposals/state/proposal_actions.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/main_dummy.dart';

class FailOnceProposalRepository extends InMemoryProposalRepository {
  bool _fail = true;
  @override
  Future<void> saveProposal(Proposal proposal) async {
    if (_fail) {
      _fail = false;
      throw StateError('offline');
    }
    await super.saveProposal(proposal);
  }
}

void main() {
  test('retry after final proposal write fails reuses existing customer and order', () async {
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        inMemoryProposalRepositoryProvider.overrideWith(FailOnceProposalRepository.new),
      ],
    );
    addTearDown(scope.dispose);
    final draft = (await scope.read(proposalDraftProvider('prop-003').future))!;
    final actions = scope.read(proposalActionsProvider('prop-003').notifier);
    expect(await actions.approve(draft), isNull);
    expect(scope.read(proposalActionsProvider('prop-003')).hasError, isTrue);
    expect((await scope.read(customerRepositoryProvider).getCustomers()).length, 49);
    expect(await actions.reject(), isFalse);
    expect(await actions.approve(draft), 'ord-ai-prop-003');
    expect((await scope.read(customerRepositoryProvider).getCustomers()).length, 49);
    expect((await scope.read(orderRepositoryProvider).getOrders()).length, 17);
    final saved = (await scope.read(proposalRepositoryProvider).getProposalById('prop-003'))!;
    expect(saved.status, ProposalStatus.disetujui);
    expect(saved.serviceId, draft.serviceId);
    expect(saved.sourceText, contains('bed cover'));
  });
}
