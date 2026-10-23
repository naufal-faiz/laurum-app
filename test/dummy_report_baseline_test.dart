import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/repository_providers.dart';
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
