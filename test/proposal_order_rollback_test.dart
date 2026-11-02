import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/customers/data/in_memory_customer_repository.dart';
import 'package:laurum/features/orders/data/in_memory_order_repository.dart';
import 'package:laurum/features/proposals/state/proposal_actions.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/main_dummy.dart';

class FailingProposalOrder extends InMemoryOrderRepository {
  @override
  Future<void> saveOrder(
    Order order, {
    List<OrderItem>? items,
    List<Payment>? payments,
    List<OrderEvent>? events,
    bool useOrderStatus = true,
  }) async {
    await super.saveOrder(
      order,
      items: items,
      payments: payments,
      events: events,
      useOrderStatus: useOrderStatus,
    );
    throw StateError('after saving proposal order');
  }
}

void main() {
  test('AI order failure restores new customer without soft-delete residue', () async {
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        inMemoryOrderRepositoryProvider.overrideWith(FailingProposalOrder.new),
      ],
    );
    addTearDown(scope.dispose);
    final draft = (await scope.read(proposalDraftProvider('prop-003').future))!;
    await scope.read(transactionRunnerProvider).run(() async {});
    final customers = scope.read(inMemoryCustomerRepositoryProvider);
    final orders = scope.read(inMemoryOrderRepositoryProvider);
    final pending = scope.read(syncServiceProvider).pendingChanges;
    expect(await scope.read(proposalActionsProvider('prop-003').notifier).approve(draft), isNull);
    expect(scope.read(inMemoryCustomerRepositoryProvider), same(customers));
    expect(scope.read(inMemoryOrderRepositoryProvider), same(orders));
    expect(scope.read(syncServiceProvider).pendingChanges, pending);
  });
}
