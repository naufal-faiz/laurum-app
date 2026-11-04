import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/app.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/core/services/contact_source.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/features/auth/data/dummy_session_overrides.dart';
import 'package:laurum/features/business/data/in_memory_business_repository.dart';
import 'package:laurum/features/customers/data/contact_fixtures.dart';
import 'package:laurum/features/customers/data/in_memory_customer_repository.dart';
import 'package:laurum/features/customers/data/in_memory_savings_repository.dart';
import 'package:laurum/features/expenses/data/in_memory_expense_repository.dart';
import 'package:laurum/features/orders/data/in_memory_order_repository.dart';
import 'package:laurum/features/printer/data/in_memory_receipt_settings_repository.dart';
import 'package:laurum/features/proposals/data/in_memory_proposal_repository.dart';
import 'package:laurum/features/reports/data/in_memory_report_repository.dart';
import 'package:laurum/features/reports/data/report_repository_view.dart';
import 'package:laurum/features/services/data/in_memory_service_repository.dart';
import 'package:laurum/features/shell/pages/app_router.dart';
import 'package:laurum/features/shell/state/shell_state.dart';

List<Override> dummyOverrides({
  ContactSource? contactSource,
  AuthService? authService,
  SyncService? syncService,
  DateTime Function()? clock,
}) => [
  businessClockProvider.overrideWithValue(clock ?? () => DateTime(2026, 10, 16, 10, 45)),
  contactSourceProvider.overrideWith(
    (ref) => contactSource ?? FakeContactSource(contacts: contactFixtures),
  ),
  ...dummySessionOverrides(authService: authService, syncService: syncService),
  receiptSettingsRepositoryProvider.overrideWith(
    (ref) => InMemoryReceiptSettingsRepository(ref.watch(businessRepositoryProvider)),
  ),
  businessRepositoryProvider.overrideWith(
    (ref) {
      ref.listen(inMemoryBusinessRepositoryProvider, (_, _) => notifyDummyWrite(ref));
      return ref.read(inMemoryBusinessRepositoryProvider.notifier);
    },
  ),
  customerRepositoryProvider.overrideWith(
    (ref) {
      ref.listen(inMemoryCustomerRepositoryProvider, (_, _) => notifyDummyWrite(ref));
      return ref.read(inMemoryCustomerRepositoryProvider.notifier);
    },
  ),
  serviceRepositoryProvider.overrideWith(
    (ref) {
      ref.listen(inMemoryServiceRepositoryProvider, (_, _) => notifyDummyWrite(ref));
      return ref.read(inMemoryServiceRepositoryProvider.notifier);
    },
  ),
  orderRepositoryProvider.overrideWith(
    (ref) {
      ref.listen(inMemoryOrderRepositoryProvider, (_, _) => notifyDummyWrite(ref));
      return ref.read(inMemoryOrderRepositoryProvider.notifier);
    },
  ),
  savingsRepositoryProvider.overrideWith(
    (ref) {
      ref.listen(inMemorySavingsRepositoryProvider, (_, _) => notifyDummyWrite(ref));
      return ref.read(inMemorySavingsRepositoryProvider.notifier);
    },
  ),
  expenseRepositoryProvider.overrideWith(
    (ref) {
      ref.listen(inMemoryExpenseRepositoryProvider, (_, _) => notifyDummyWrite(ref));
      return ref.read(inMemoryExpenseRepositoryProvider.notifier);
    },
  ),
  proposalRepositoryProvider.overrideWith(
    (ref) {
      ref.listen(inMemoryProposalRepositoryProvider, (_, _) => notifyDummyWrite(ref));
      return ref.read(inMemoryProposalRepositoryProvider.notifier);
    },
  ),
  reportRepositoryProvider.overrideWith(
    (ref) {
      ref.watch(inMemoryReportRepositoryProvider);
      return ReportRepositoryView(ref.read(inMemoryReportRepositoryProvider.notifier));
    },
  ),
];

final dummyRepositoryOverrides = dummyOverrides();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  final container = ProviderContainer(overrides: dummyRepositoryOverrides);
  final app = LaurumApp(router: createAppRouter(container: container));
  runApp(UncontrolledProviderScope(container: container, child: app));
}
