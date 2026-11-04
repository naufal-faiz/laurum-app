import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/id_generator.dart';
import 'package:laurum/core/services/local_settings_providers.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/proposals/state/proposal_actions.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  late ProviderContainer scope;
  setUp(() => scope = ProviderContainer(overrides: dummyRepositoryOverrides));
  tearDown(() => scope.dispose());
  test('real checkout uses UUIDs, keeps nota number and saves device counter', () async {
    scope.read(transactionDraftProvider.notifier)
      ..selectCustomer('cust-001')
      ..add(serviceFixtures.firstWhere((s) => s.id == 'srv-004'));
    scope.read(checkoutControllerProvider.notifier)
      ..setTerm(PayTerm.sekarang)
      ..setReceived(30000, due: 25000)
      ..setExcess(save: true);
    final id = (await scope.read(checkoutControllerProvider.notifier).save())!;
    final repo = scope.read(orderRepositoryProvider);
    expect(id[14], '4');
    expect((await repo.getOrderById(id))!.orderNo, 'A-0143');
    final rows = [
      id,
      ...(await repo.getItemsByOrderId(id)).map((i) => i.id),
      ...(await repo.getPaymentsByOrderId(id)).map((p) => p.id),
      ...(await repo.getEventsByOrderId(id)).map((e) => e.id),
    ];
    expect(rows.toSet(), hasLength(rows.length));
    for (final value in rows) {
      expect(value[14], '4');
    }
    final payment = (await repo.getPaymentsByOrderId(id)).single;
    final excess = (await scope.read(savingsRepositoryProvider).getAllEntries()).singleWhere(
      (e) => e.orderId == id,
    );
    expect(excess.id, const IdGenerator().derived(payment.id, 'excess'));
    expect(await scope.read(localSettingsRepositoryProvider).getInt('order_counter_A'), 143);
  });
  test('approval retries reuse UUID v5 order and customer without duplicates', () async {
    final draft = (await scope.read(proposalDraftProvider('prop-003').future))!;
    final actions = scope.read(proposalActionsProvider('prop-003').notifier);
    final id = await actions.approve(draft);
    expect(id, const IdGenerator().derived('prop-003', 'order'));
    expect(await actions.approve(draft), id);
    final repo = scope.read(orderRepositoryProvider);
    expect((await repo.getOrders()).where((o) => o.proposalId == 'prop-003'), hasLength(1));
    expect(
      (await repo.getOrderById(id!))!.customerId,
      const IdGenerator().derived('prop-003', 'customer'),
    );
    expect((await scope.read(customerRepositoryProvider).getCustomers()), hasLength(49));
  });
}
