import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/repositories/savings_repository.dart';
import 'package:laurum/core/domain/savings_entry.dart';
import 'package:laurum/core/domain/savings_rules.dart';

import '../domain_samples.dart';
import 'repository_factory.dart';

void runSavingsExtraContract(RepositoryFactory<SavingsRepository> factory) {
  test('signed adjustments, empty balance and equal-time ordering match domain SUM', () async {
    final repo = await factory();
    await repo.addEntry(saving('z'));
    await repo.addEntry(saving('a', amount: -20, kind: SavingsKind.penyesuaian));
    await repo.addEntry(saving('b', amount: 10, kind: SavingsKind.pakai));
    final ledger = await repo.getAllEntries();
    expect(await repo.getBalance('c'), 70);
    expect(await repo.getBalance('empty'), 0);
    expect(await repo.getBalance('c'), savingsBalance(ledger, customerId: 'c'));
    expect((await repo.getEntriesByCustomerId('c')).map((e) => e.id), ['z', 'a', 'b']);
    expect(ledger.every((e) => e.orderId == null && e.note.isEmpty), isTrue);
  });
  test('retry ignores sync metadata but immutable business payload cannot change', () async {
    final repo = await factory();
    final original = saving('a');
    await repo.addEntry(original);
    await repo.addEntry(
      SavingsEntry(
        id: original.id,
        ownerId: original.ownerId,
        createdAt: original.createdAt,
        updatedAt: day.add(const Duration(days: 1)),
        syncState: RecordSyncState.synced,
        customerId: original.customerId,
        kind: original.kind,
        amount: original.amount,
        method: original.method,
      ),
    );
    expect(await repo.getAllEntries(), hasLength(1));
    await expectLater(repo.addEntry(saving('a', amount: 99)), throwsStateError);
  });
}
