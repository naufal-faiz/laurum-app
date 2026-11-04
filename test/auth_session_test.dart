import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/report_totals.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/features/proposals/state/proposal_history.dart';
import 'package:laurum/features/reports/data/report_samples.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  test('logout keeps local data and next login restores session', () async {
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(scope.dispose);
    final session = scope.read(authSessionProvider.notifier);
    expect(await session.signOut(), isTrue);
    expect(scope.read(authSessionProvider).signedIn, isFalse);
    expect((await scope.read(customerRepositoryProvider).getCustomers()).length, 48);
    expect(await session.signIn(), isTrue);
    expect(scope.read(authSessionProvider).signedIn, isTrue);
    expect((scope.read(syncServiceProvider) as FakeSyncService).syncCallCount, 1);
  });
  test('account deletion clears repositories, baselines and local drafts', () async {
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(scope.dispose);
    final session = scope.read(authSessionProvider.notifier);
    expect(await session.deleteAccount(), isTrue);
    expect(scope.read(authSessionProvider).signedIn, isFalse);
    expect(scope.read(authSessionProvider).needsSetup, isTrue);
    expect(await scope.read(customerRepositoryProvider).getCustomers(), isEmpty);
    expect(await scope.read(orderRepositoryProvider).getOrders(), isEmpty);
    expect(await scope.read(expenseRepositoryProvider).getExpenses(), isEmpty);
    expect(await scope.read(serviceRepositoryProvider).getServices(), isEmpty);
    expect(await scope.read(savingsRepositoryProvider).getAllEntries(), isEmpty);
    expect((await scope.read(businessRepositoryProvider).getProfile()).name, '');
    expect(await scope.read(reportRepositoryProvider).getReport(weekRange), const ReportTotals());
    expect((await scope.read(proposalHistoryProvider.future)).count(ProposalStatus.disetujui), 0);
    expect(scope.read(transactionDraftProvider).lines, isEmpty);
  });
  test('failed account deletion preserves authenticated data', () async {
    final scope = ProviderContainer(
      overrides: dummyOverrides(authService: FakeAuthService(deleteSucceeds: false)),
    );
    addTearDown(scope.dispose);
    expect(await scope.read(authSessionProvider.notifier).deleteAccount(), isFalse);
    expect(scope.read(authSessionProvider).signedIn, isTrue);
    expect((await scope.read(customerRepositoryProvider).getCustomers()).length, 48);
  });
  test('cancelled Google sign in stays signed out and can retry', () async {
    final scope = ProviderContainer(
      overrides: dummyOverrides(
        authService: FakeAuthService(isSignedIn: false, signInSucceeds: false),
      ),
    );
    addTearDown(scope.dispose);
    expect(await scope.read(authSessionProvider.notifier).signIn(), isFalse);
    expect(scope.read(authSessionProvider).signedIn, isFalse);
    expect(scope.read(authSessionProvider).error, isNotNull);
  });
}
