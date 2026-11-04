import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/reports/data/report_samples.dart';
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

    test('report repository menghitung ledger yang konsisten untuk semua periode', () async {
      final reportRepo = container.read(reportRepositoryProvider);
      final weekReport = await reportRepo.getReport(weekRange);
      expect(weekReport.revenue, 589000);
      expect(weekReport.transactionCount, 14);
      expect(weekReport.expenses, 850000);
      expect(weekReport.cashIn, 500000);
      expect(weekReport.activeOutstanding, 400500);
      expect(weekReport.savingsBalance, 430000);

      final todayReport = await reportRepo.getReport(todayRange);
      expect(todayReport.revenue, 177000);
      expect(todayReport.transactionCount, 6);
      expect(todayReport.expenses, 145000);

      final monthReport = await reportRepo.getReport(monthRange);
      expect(monthReport.revenue, 864000);
      expect(monthReport.expenses, 1850000);
    });
  });
}
