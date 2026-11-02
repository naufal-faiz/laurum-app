import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/dummy_history.dart';
import 'package:laurum/core/services/in_memory_transaction_runner.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/services/transaction_runner.dart';

TransactionRunner dummyTransactionRunner(Ref ref) => InMemoryTransactionRunner(() {
  final stores = <Object>[
    ref.read(orderRepositoryProvider),
    ref.read(customerRepositoryProvider),
    ref.read(savingsRepositoryProvider),
    ref.read(expenseRepositoryProvider),
    ref.read(serviceRepositoryProvider),
    ref.read(proposalRepositoryProvider),
    ref.read(businessRepositoryProvider),
    ref.read(dummyHistoryProvider.notifier),
    ref.read(authServiceProvider),
    ref.read(syncServiceProvider),
  ];
  // Fail before any writes if a replacement store cannot participate.
  return [for (final store in stores) store as TransactionParticipant];
});
