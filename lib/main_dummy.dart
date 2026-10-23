import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/app.dart';
import 'package:laurum/core/domain/repositories/repository_providers.dart';
import 'package:laurum/features/business/data/in_memory_business_repository.dart';
import 'package:laurum/features/customers/data/in_memory_customer_repository.dart';
import 'package:laurum/features/customers/data/in_memory_savings_repository.dart';
import 'package:laurum/features/expenses/data/in_memory_expense_repository.dart';
import 'package:laurum/features/orders/data/in_memory_order_repository.dart';
import 'package:laurum/features/proposals/data/in_memory_proposal_repository.dart';
import 'package:laurum/features/reports/data/in_memory_report_repository.dart';
import 'package:laurum/features/services/data/in_memory_service_repository.dart';

final dummyRepositoryOverrides = [
  businessRepositoryProvider.overrideWith(
    (ref) => ref.watch(inMemoryBusinessRepositoryProvider.notifier),
  ),
  customerRepositoryProvider.overrideWith(
    (ref) => ref.watch(inMemoryCustomerRepositoryProvider.notifier),
  ),
  serviceRepositoryProvider.overrideWith(
    (ref) => ref.watch(inMemoryServiceRepositoryProvider.notifier),
  ),
  orderRepositoryProvider.overrideWith(
    (ref) => ref.watch(inMemoryOrderRepositoryProvider.notifier),
  ),
  savingsRepositoryProvider.overrideWith(
    (ref) => ref.watch(inMemorySavingsRepositoryProvider.notifier),
  ),
  expenseRepositoryProvider.overrideWith(
    (ref) => ref.watch(inMemoryExpenseRepositoryProvider.notifier),
  ),
  proposalRepositoryProvider.overrideWith(
    (ref) => ref.watch(inMemoryProposalRepositoryProvider.notifier),
  ),
  reportRepositoryProvider.overrideWith(
    (ref) => ref.watch(inMemoryReportRepositoryProvider.notifier),
  ),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  runApp(
    ProviderScope(
      overrides: dummyRepositoryOverrides,
      child: const LaurumApp(),
    ),
  );
}
