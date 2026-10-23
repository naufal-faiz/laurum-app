import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/domain/order_number_generator.dart';
import 'package:laurum/core/domain/repositories/repository_providers.dart';
import 'package:laurum/core/domain/savings_rules.dart';
import 'package:laurum/features/customers/data/customer_fixtures.dart';
import 'package:laurum/features/customers/data/savings_fixtures.dart';
import 'package:laurum/features/orders/data/order_fixtures.dart';
import 'package:laurum/features/orders/data/payment_fixtures.dart';
import 'package:laurum/features/reports/data/report_fixtures.dart';
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

    test('antrean aktif 12 order: 3 jemput, 5 proses, 4 siap', () async {
      final orderRepo = container.read(orderRepositoryProvider);
      final jemput = await orderRepo.getOrders(status: OrderStatus.menungguJemput);
      final proses = await orderRepo.getOrders(status: OrderStatus.diproses);
      final siap = await orderRepo.getOrders(status: OrderStatus.siap);

      expect(jemput.length, 3);
      expect(proses.length, 5);
      expect(siap.length, 4);
      expect(jemput.length + proses.length + siap.length, 12);
    });

    test('piutang tepat Rp400.500 dari 5 nota', () async {
      final totalOutstanding = outstanding(orderFixtures, paymentFixtures);
      expect(totalOutstanding, 400500);

      final piutangOrders = orderFixtures.where((o) {
        if (o.status == OrderStatus.dibatalkan) return false;
        final paid = paidAmount(paymentFixtures.where((p) => p.orderId == o.id));
        return paid < o.total;
      }).toList();

      expect(piutangOrders.length, 5);
      final nos = piutangOrders.map((o) => o.orderNo).toSet();
      expect(nos, {'A-0128', 'A-0136', 'A-0138', 'A-0140', 'A-0142'});
    });

    test('saldo tabungan Pak Dedi Rp50.000 dengan mutasi urut', () async {
      final savingsRepo = container.read(savingsRepositoryProvider);
      final balance = await savingsRepo.getBalance('cust-001');
      expect(balance, 50000);

      final pakDediEntries = await savingsRepo.getEntriesByCustomerId('cust-001');
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

    test('generator menghasilkan nomor nota berikutnya A-0143', () {
      const gen = OrderNumberGenerator();
      final next = gen.nextOrderNo(orderFixtures.map((o) => o.orderNo));
      expect(next, 'A-0143');
    });

    test('pelanggan total 48 orang dengan 5 punya piutang dan 5 tabungan', () {
      expect(customerFixtures.length, 48);
      final customerIdsWithSavings = savingsFixtures.map((s) => s.customerId).toSet();
      expect(customerIdsWithSavings.length, 5);
    });

    test('report repository menghasilkan baseline laporan yang konsisten', () async {
      final reportRepo = container.read(reportRepositoryProvider);
      final weekReport = await reportRepo.getReport(weekRange);
      expect(weekReport.revenue, 1800000);
      expect(weekReport.transactionCount, 58);
      expect(weekReport.expenses, 850000);
      expect(weekReport.cashIn, 1699500);
      expect(weekReport.activeOutstanding, 400500);
      expect(weekReport.savingsBalance, 430000);

      final todayReport = await reportRepo.getReport(todayRange);
      expect(todayReport.revenue, 375000);
      expect(todayReport.transactionCount, 12);
      expect(todayReport.expenses, 145000);

      final monthReport = await reportRepo.getReport(monthRange);
      expect(monthReport.revenue, 4250000);
      expect(monthReport.expenses, 1850000);
    });
  });
}
