import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/proposals/state/proposal_actions.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

import 'antrean_test_host.dart';

const heldMessage = 'Order untuk pembatalan ini belum diketahui. Usulan tetap menunggu.';

Future<ProviderContainer> cancellationScope(String? orderId) async {
  final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
  final repo = scope.read(proposalRepositoryProvider);
  final original = (await repo.getProposalById('prop-001'))!;
  await repo.saveProposal(
    Proposal(
      id: original.id,
      ownerId: original.ownerId,
      createdAt: original.createdAt,
      status: ProposalStatus.menunggu,
      sourceText: original.sourceText,
      customerName: original.customerName,
      phone: original.phone,
      customerId: original.customerId,
      orderId: orderId,
      cancelRequested: true,
    ),
  );
  return scope;
}

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final orderId in [null, 'missing-order']) {
    test('unlinked cancellation $orderId preserves all stores', () async {
      final scope = await cancellationScope(orderId);
      addTearDown(scope.dispose);
      final orders = scope.read(orderRepositoryProvider);
      final beforeOrders = await orders.getOrders();
      final beforePayments = await orders.getPaymentsByOrderId('ord-0139');
      final savings = scope.read(savingsRepositoryProvider);
      final beforeSavings = await savings.getAllEntries();
      final beforePending = scope.read(syncServiceProvider).pendingChanges;
      final draft = (await scope.read(proposalDraftProvider('prop-001').future))!;
      final actions = scope.read(proposalActionsProvider('prop-001').notifier);
      expect(await actions.approve(draft), isNull);
      expect(
        scope.read(proposalActionsProvider('prop-001')).error.toString(),
        contains(heldMessage),
      );
      expect(await orders.getOrders(), beforeOrders);
      expect(await orders.getPaymentsByOrderId('ord-0139'), beforePayments);
      expect(await savings.getAllEntries(), beforeSavings);
      expect(scope.read(syncServiceProvider).pendingChanges, beforePending);
      final proposal = await scope.read(proposalRepositoryProvider).getProposalById('prop-001');
      expect(proposal!.status, ProposalStatus.menunggu);
      expect(proposal.sourceText, isNotEmpty);
    });
    testWidgets('unlinked cancellation $orderId shows an explanation without confirmation', (
      tester,
    ) async {
      final scope = await cancellationScope(orderId);
      await pumpAntrean(tester, location: '/antrean/usulan/prop-001', container: scope);
      await tester.tap(find.widgetWithText(AppButton, 'Batalkan order'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text(heldMessage), findsOneWidget);
      expect(find.text('Ya, batalkan order'), findsNothing);
      final proposal = await scope.read(proposalRepositoryProvider).getProposalById('prop-001');
      expect(proposal!.status, ProposalStatus.menunggu);
      expect(
        (await scope.read(orderRepositoryProvider).getOrderById('ord-0139'))!.status,
        OrderStatus.menungguJemput,
      );
    });
  }
}
