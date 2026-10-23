import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/savings_rules.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  group('Data Dummy Integration Test', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(overrides: dummyRepositoryOverrides);
    });

    tearDown(() {
      container.dispose();
    });

    test('saldo tabungan Pak Dedi Rp50.000 dengan mutasi urut', () async {
      final savingsRepo = container.read(savingsRepositoryProvider);
      final balance = await savingsRepo.getBalance('cust-001');
      expect(balance, 50000);

      final newestFirst = await savingsRepo.getEntriesByCustomerId('cust-001');
      expect(newestFirst.first.amount, 50000);
      final pakDediEntries = newestFirst.reversed.toList();
      expect(pakDediEntries.length, 3);

      expect(pakDediEntries[0].amount, 25000);
      expect(pakDediEntries[0].kind, SavingsKind.setor);

      expect(pakDediEntries[1].amount, 25000);
      expect(pakDediEntries[1].kind, SavingsKind.pakai);
      expect(pakDediEntries[1].orderId, 'ord-0115');

      expect(pakDediEntries[2].amount, 50000);
      expect(pakDediEntries[2].kind, SavingsKind.setor);

      var runningBalance = 0;
      runningBalance = savingsBalance([pakDediEntries[0]]);
      expect(runningBalance, 25000);
      runningBalance = savingsBalance([pakDediEntries[0], pakDediEntries[1]]);
      expect(runningBalance, 0);
      runningBalance = savingsBalance(pakDediEntries);
      expect(runningBalance, 50000);
    });
  });
}
