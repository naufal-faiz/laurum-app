import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/dummy_history.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/features/business/data/in_memory_business_repository.dart';
import 'package:laurum/features/customers/data/in_memory_customer_repository.dart';
import 'package:laurum/features/customers/data/in_memory_savings_repository.dart';
import 'package:laurum/features/expenses/data/in_memory_expense_repository.dart';
import 'package:laurum/features/orders/data/in_memory_order_repository.dart';
import 'package:laurum/features/proposals/data/in_memory_proposal_repository.dart';
import 'package:laurum/features/services/data/in_memory_service_repository.dart';
import 'package:laurum/main_dummy.dart';

class FailingClearSync extends FakeSyncService {
  @override
  void clearLocalState() {
    super.clearLocalState();
    throw StateError('after all local repositories cleared');
  }
}

void main() {
  test('account cleanup failure restores every store, category, sync and session', () async {
    final sync = FailingClearSync();
    addTearDown(sync.dispose);
    final scope = ProviderContainer(overrides: dummyOverrides(syncService: sync));
    addTearDown(scope.dispose);
    await scope.read(transactionRunnerProvider).run(() async {});
    final orders = scope.read(inMemoryOrderRepositoryProvider);
    final customers = scope.read(inMemoryCustomerRepositoryProvider);
    final savings = scope.read(inMemorySavingsRepositoryProvider);
    final expenses = scope.read(inMemoryExpenseRepositoryProvider);
    final services = scope.read(inMemoryServiceRepositoryProvider);
    final proposals = scope.read(inMemoryProposalRepositoryProvider);
    final business = scope.read(inMemoryBusinessRepositoryProvider);
    final categories = await scope.read(expenseRepositoryProvider).getCategories();
    sync.recordLocalChange();
    final pending = sync.pendingChanges, status = sync.currentStatus, last = sync.lastSyncedAt;
    expect(await scope.read(authSessionProvider.notifier).deleteAccount(), isFalse);
    expect(scope.read(inMemoryOrderRepositoryProvider), same(orders));
    expect(scope.read(inMemoryCustomerRepositoryProvider), same(customers));
    expect(scope.read(inMemorySavingsRepositoryProvider), same(savings));
    expect(scope.read(inMemoryExpenseRepositoryProvider), same(expenses));
    expect(scope.read(inMemoryServiceRepositoryProvider), same(services));
    expect(scope.read(inMemoryProposalRepositoryProvider), same(proposals));
    expect(scope.read(inMemoryBusinessRepositoryProvider), business);
    expect(await scope.read(expenseRepositoryProvider).getCategories(), categories);
    expect(scope.read(dummyHistoryProvider), isTrue);
    expect(scope.read(authSessionProvider).signedIn, isTrue);
    expect(sync.pendingChanges, pending);
    expect(sync.currentStatus, status);
    expect(sync.lastSyncedAt, last);
  });
}
