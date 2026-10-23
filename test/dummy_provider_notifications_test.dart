import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/receipt_settings.dart';
import 'package:laurum/core/domain/savings_entry.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/business/data/business_fixtures.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  test('all remaining repository interfaces publish writes and isolate containers', () async {
    final container = ProviderContainer(overrides: dummyRepositoryOverrides);
    final other = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(container.dispose);
    addTearDown(other.dispose);
    final counts = <int, int>{};
    final providers = [
      businessRepositoryProvider,
      serviceRepositoryProvider,
      savingsRepositoryProvider,
      expenseRepositoryProvider,
      proposalRepositoryProvider,
    ];
    final subscriptions = [
      for (var i = 0; i < providers.length; i++)
        container.listen(providers[i], (_, _) => counts.update(i, (n) => n + 1, ifAbsent: () => 1)),
    ];
    await container
        .read(businessRepositoryProvider)
        .saveReceiptSettings(
          ReceiptSettings(
            id: receiptSettingsFixture.id,
            ownerId: dummyOwnerId,
            createdAt: receiptSettingsFixture.createdAt,
            paperMm: 80,
          ),
        );
    await container.read(serviceRepositoryProvider).deleteService('srv-001');
    await container
        .read(savingsRepositoryProvider)
        .addEntry(
          SavingsEntry(
            id: 'deposit',
            ownerId: dummyOwnerId,
            createdAt: DateTime(2026, 10, 16, 11),
            customerId: 'cust-001',
            kind: SavingsKind.setor,
            amount: 1000,
            method: PayMethod.tunai,
          ),
        );
    await container.read(expenseRepositoryProvider).deleteExpense('exp-018');
    await container
        .read(proposalRepositoryProvider)
        .updateProposalStatus(
          'prop-001',
          ProposalStatus.ditolak,
        );
    await container.pump();
    expect(counts.keys, containsAll([0, 1, 2, 3, 4]));
    expect(
      (await container.read(serviceRepositoryProvider).getServices(includeInactive: true)).length,
      5,
    );
    expect(await container.read(savingsRepositoryProvider).getBalance('cust-001'), 51000);
    expect(await other.read(savingsRepositoryProvider).getBalance('cust-001'), 50000);
    for (final sub in subscriptions) {
      sub.close();
    }
  });
}
