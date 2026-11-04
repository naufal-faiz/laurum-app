import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/repositories/savings_repository.dart';

import '../domain_samples.dart';
import 'repository_factory.dart';

void runSavingsRepositoryContract(RepositoryFactory<SavingsRepository> factory) {
  late SavingsRepository repo;
  setUp(() async => repo = await factory());
  test('ledger balance, customer isolation and descending history', () async {
    expect(await repo.getBalance('c'), 0);
    await repo.addEntry(saving('a'));
    final used = saving(
      'b',
      amount: 40,
      kind: SavingsKind.pakai,
      createdAt: day.add(const Duration(days: 1)),
    );
    await repo.addEntry(used);
    await repo.addEntry(saving('other', customerId: 'other'));
    expect(await repo.getBalance('c'), 60);
    expect((await repo.getEntriesByCustomerId('c')).first, used);
    expect(await repo.getAllEntries(), hasLength(3));
    expect((await repo.getAllEntries()).clear, throwsUnsupportedError);
  });
  test('retry is idempotent; conflicting payload and insufficient balance reject', () async {
    final entry = saving('a');
    await repo.addEntry(entry);
    await repo.addEntry(entry);
    expect(await repo.getAllEntries(), [entry]);
    await expectLater(repo.addEntry(saving('a', amount: 20)), throwsStateError);
    await expectLater(
      repo.addEntry(saving('b', amount: 101, kind: SavingsKind.pakai)),
      throwsStateError,
    );
    await expectLater(repo.addEntry(saving('z', amount: 0)), throwsArgumentError);
    expect(await repo.getBalance('c'), 100);
  });
}
