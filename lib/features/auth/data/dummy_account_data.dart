import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/dummy_history.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/business/data/in_memory_business_repository.dart';
import 'package:laurum/features/business/state/business_info_controller.dart';
import 'package:laurum/features/customers/data/in_memory_customer_repository.dart';
import 'package:laurum/features/customers/data/in_memory_savings_repository.dart';
import 'package:laurum/features/expenses/data/in_memory_expense_repository.dart';
import 'package:laurum/features/expenses/state/expense_form_controller.dart';
import 'package:laurum/features/orders/data/in_memory_order_repository.dart';
import 'package:laurum/features/proposals/data/in_memory_proposal_repository.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/features/services/data/in_memory_service_repository.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';

Future<void> clearDummyAccountData(Ref ref) async {
  await ref.read(transactionRunnerProvider).run(() async {
    ref.read(dummyHistoryProvider.notifier).clear();
    ref.read(inMemoryOrderRepositoryProvider.notifier).clearLocalData();
    ref.read(inMemoryCustomerRepositoryProvider.notifier).clearLocalData();
    ref.read(inMemorySavingsRepositoryProvider.notifier).clearLocalData();
    ref.read(inMemoryExpenseRepositoryProvider.notifier).clearLocalData();
    ref.read(inMemoryServiceRepositoryProvider.notifier).clearLocalData();
    ref.read(inMemoryProposalRepositoryProvider.notifier).clearLocalData();
    ref.read(inMemoryBusinessRepositoryProvider.notifier).clearLocalData();
    ref.read(syncServiceProvider).clearLocalState();
  });
  ref.invalidate(transactionDraftProvider);
  ref.invalidate(expenseFormProvider);
  ref.invalidate(proposalDraftProvider);
  ref.invalidate(businessInfoProvider);
}
