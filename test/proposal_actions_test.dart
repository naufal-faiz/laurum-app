import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/proposals/state/proposal_actions.dart';
import 'package:laurum/features/proposals/state/proposal_history.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  for (final mode in [true, false]) {
    test('Rina approval uses status policy $mode and leaves weight empty', () async {
      final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
      addTearDown(scope.dispose);
      final business = scope.read(businessRepositoryProvider);
      await business.saveProfile((await business.getProfile()).withOrderStatus(enabled: mode));
      final draft = (await scope.read(proposalDraftProvider('prop-002').future))!;
      final actions = scope.read(proposalActionsProvider('prop-002').notifier);
      final id = await actions.approve(draft);
      final order = (await scope.read(orderRepositoryProvider).getOrderById(id!))!;
      expect(order.status, mode ? OrderStatus.menungguJemput : OrderStatus.diproses);
      expect(order.source, OrderSource.whatsappAi);
      expect(order.total, 0);
      expect(order.proposalId, 'prop-002');
      expect((await scope.read(orderRepositoryProvider).getItemsByOrderId(id)).single.qtyMilli, 0);
      expect((await scope.read(antreanDataProvider.future)).orders.length, 13);
      expect(await actions.approve(draft), id);
      expect((await scope.read(orderRepositoryProvider).getOrders()).length, 17);
      final history = await scope.read(proposalHistoryProvider.future);
      expect(history.count(ProposalStatus.disetujui), 143);
      expect(history.count(ProposalStatus.menunggu), 2);
    });
  }
  test('new Agus only created on approval; repeat cannot create a duplicate', () async {
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(scope.dispose);
    final customers = scope.read(customerRepositoryProvider);
    expect((await customers.getCustomers()).length, 48);
    final draft = (await scope.read(proposalDraftProvider('prop-003').future))!;
    expect((await customers.getCustomers()).length, 48);
    final actions = scope.read(proposalActionsProvider('prop-003').notifier);
    final id = await actions.approve(draft);
    expect(id, isNotNull);
    expect((await customers.getCustomers()).length, 49);
    final order = (await scope.read(orderRepositoryProvider).getOrderById(id!))!;
    expect(order.total, 25000);
    expect((await customers.getCustomerById(order.customerId))!.name, 'Agus Pratama');
    expect(await actions.approve(draft), id);
    expect((await customers.getCustomers()).length, 49);
    expect(await actions.reject(), isFalse);
  });
  test('Rudi cancellation corrects payment and removes order from active queue', () async {
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(scope.dispose);
    final draft = (await scope.read(proposalDraftProvider('prop-001').future))!;
    final id = await scope.read(proposalActionsProvider('prop-001').notifier).approve(draft);
    expect(id, 'ord-0139');
    final repo = scope.read(orderRepositoryProvider);
    expect((await repo.getOrderById(id!))!.status, OrderStatus.dibatalkan);
    expect((await repo.getPaymentsByOrderId(id)).fold(0, (sum, p) => sum + p.amount), 0);
    expect((await scope.read(antreanDataProvider.future)).orders.length, 11);
  });
  test('reject keeps customers/orders intact and updates history counts', () async {
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(scope.dispose);
    expect(await scope.read(proposalActionsProvider('prop-003').notifier).reject(), isTrue);
    expect((await scope.read(customerRepositoryProvider).getCustomers()).length, 48);
    expect((await scope.read(orderRepositoryProvider).getOrders()).length, 16);
    expect((await scope.read(proposalHistoryProvider.future)).count(ProposalStatus.ditolak), 9);
  });
}
