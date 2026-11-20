import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/proposals/data/in_memory_proposal_repository.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  Proposal seed(int? grams, {String service = 'srv-003'}) => Proposal(
    id: 'weight-test',
    ownerId: 'owner',
    createdAt: DateTime(2026),
    status: ProposalStatus.menunggu,
    sourceText: 'Cuci pakaian',
    customerName: 'Sari',
    serviceId: service,
    estimatedWeightGrams: grams,
  );

  ProviderContainer scope(int? grams, {String service = 'srv-003'}) {
    final container = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        proposalSeedProvider.overrideWithValue([
          seed(grams, service: service),
        ]),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  for (final entry in <int?, String>{null: '', 2000: '2', 2500: '2,5', 500: '0,5'}.entries) {
    test('estimated grams ${entry.key} initialize the existing weight field', () async {
      final c = scope(entry.key);
      final draft = await c.read(proposalDraftProvider('weight-test').future);
      expect(draft!.weight, entry.value);
      expect(draft.weightMilli, entry.key ?? 0);
    });
  }
  test('pcs never receives kilograms; selecting kiloan loads the estimate', () async {
    final c = scope(2000, service: 'srv-004');
    expect((await c.read(proposalDraftProvider('weight-test').future))!.weight, '');
    c.read(proposalDraftProvider('weight-test').notifier).service('srv-003');
    expect(c.read(proposalDraftProvider('weight-test')).value!.weight, '2');
  });
  test('owner corrections survive a refreshed AI proposal', () async {
    final c = scope(2000);
    await c.read(proposalDraftProvider('weight-test').future);
    c.read(proposalDraftProvider('weight-test').notifier).weight('3,5');
    await c
        .read(proposalRepositoryProvider)
        .saveProposal(
          seed(3000),
        );
    c.invalidate(proposalReviewProvider('weight-test'));
    await c.read(proposalReviewProvider('weight-test').future);
    expect(c.read(proposalDraftProvider('weight-test')).value!.weight, '3,5');
  });
  test('a small explicit weight is not rounded to the minimum', () async {
    final c = scope(200);
    final draft = (await c.read(proposalDraftProvider('weight-test').future))!;
    expect(draft.weight, '0,2');
    expect(draft.weightMilli, 200);
    expect(draft.weightError, isNotNull);
    expect(
      (await c.read(proposalReviewProvider('weight-test').future))!.canApprove(draft),
      isFalse,
    );
  });
  test('an untouched draft follows a newly stated estimate on refresh', () async {
    final c = scope(null);
    await c.read(proposalDraftProvider('weight-test').future);
    final repo = c.read(proposalRepositoryProvider);
    await repo.saveProposal(
      seed(2000),
    );
    c.invalidate(proposalReviewProvider('weight-test'));
    await c.read(proposalReviewProvider('weight-test').future);
    expect(c.read(proposalDraftProvider('weight-test')).value!.weight, '2');
  });
}
