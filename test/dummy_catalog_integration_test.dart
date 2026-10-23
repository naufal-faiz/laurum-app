import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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

    test('kategori dan total pengeluaran Okt 2026', () async {
      final expenseRepo = container.read(expenseRepositoryProvider);
      final categories = await expenseRepo.getCategories();
      expect(categories.length, 5);

      final expenses = await expenseRepo.getExpenses();
      expect(expenses.length, 18);
      final totalAmount = expenses.fold<int>(0, (sum, e) => sum + e.amount);
      expect(totalAmount, 1850000);

      final bahanCuci = expenses
          .where((e) => e.categoryId == 'cat-001')
          .fold<int>(0, (s, e) => s + e.amount);
      final listrikAir = expenses
          .where((e) => e.categoryId == 'cat-002')
          .fold<int>(0, (s, e) => s + e.amount);
      final kemasan = expenses
          .where((e) => e.categoryId == 'cat-003')
          .fold<int>(0, (s, e) => s + e.amount);

      expect(bahanCuci, 850000);
      expect(listrikAir, 620000);
      expect(kemasan, 380000);
    });

    test('katalog layanan berjumlah 6 dengan 1 nonaktif', () async {
      final serviceRepo = container.read(serviceRepositoryProvider);
      final allServices = await serviceRepo.getServices(includeInactive: true);
      final activeServices = await serviceRepo.getServices();

      expect(allServices.length, 6);
      expect(activeServices.length, 5);
      final inactive = allServices.where((s) => !s.isActive).first;
      expect(inactive.name, 'Jas & gaun');
      expect(inactive.price, 35000);
      expect(inactive.durationDays, 4);
    });
  });
}
