import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/proposals/data/in_memory_proposal_repository.dart';
import 'package:laurum/features/proposals/data/proposal_fixtures.dart';
import 'package:laurum/features/proposals/state/proposal_actions.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  for (final edited in [false, true]) {
    test(
      'explicit approval uses ${edited ? 'owner correction' : 'AI estimate'} exactly once',
      () async {
        final p = proposalFixtures[1];
        final scope = ProviderContainer(
          overrides: [
            ...dummyRepositoryOverrides,
            proposalSeedProvider.overrideWithValue([
              Proposal(
                id: p.id,
                ownerId: p.ownerId,
                createdAt: p.createdAt,
                status: p.status,
                sourceText: 'Cuci 2 kg',
                customerId: p.customerId,
                customerName: p.customerName,
                phone: p.phone,
                address: p.address,
                serviceId: p.serviceId,
                estimatedWeightGrams: 2000,
              ),
            ]),
          ],
        );
        addTearDown(scope.dispose);
        await scope.read(proposalDraftProvider(p.id).future);
        if (edited) scope.read(proposalDraftProvider(p.id).notifier).weight('2,5');
        final draft = scope.read(proposalDraftProvider(p.id)).value!;
        final repo = scope.read(orderRepositoryProvider);
        final before = (await repo.getOrders()).length;
        final actions = scope.read(proposalActionsProvider(p.id).notifier);
        final id = await actions.approve(draft);
        expect(id, isNotNull);
        final order = (await repo.getOrderById(id!))!;
        final item = (await repo.getItemsByOrderId(id)).single;
        expect(item.qtyMilli, edited ? 2500 : 2000);
        expect(order.total, edited ? 22500 : 18000);
        expect(await repo.getPaymentsByOrderId(id), isEmpty);
        expect(await actions.approve(draft), id);
        expect((await repo.getOrders()).length, before + 1);
      },
    );
  }
}
