import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/report.dart';
import 'package:laurum/core/domain/report_baseline.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/report_totals.dart';
import 'package:laurum/core/domain/repositories/report_repository.dart';
import 'package:laurum/core/domain/service_revenue.dart';
import 'package:laurum/features/customers/data/in_memory_savings_repository.dart';
import 'package:laurum/features/customers/data/savings_fixtures.dart';
import 'package:laurum/features/expenses/data/expense_fixtures.dart';
import 'package:laurum/features/expenses/data/in_memory_expense_repository.dart';
import 'package:laurum/features/orders/data/in_memory_order_repository.dart';
import 'package:laurum/features/orders/data/order_fixtures.dart';
import 'package:laurum/features/orders/data/payment_fixtures.dart';
import 'package:laurum/features/reports/data/report_fixtures.dart';

class InMemoryReportRepository extends Notifier<ReportTotals> implements ReportRepository {
  @override
  ReportTotals build() => weekBaseline.totals;

  @override
  Future<ReportBaseline> getBaseline(ReportRange range) async {
    if (range == todayRange) return todayBaseline;
    if (range == monthRange) return monthBaseline;
    return weekBaseline;
  }

  @override
  Future<ReportTotals> getReport(ReportRange range) async {
    final baseline = await getBaseline(range);
    final allOrders = ref.read(inMemoryOrderRepositoryProvider);
    final initialIds = orderFixtures.map((o) => o.id).toSet();
    final deltaOrders = allOrders.where((o) => !initialIds.contains(o.id));

    final allPayments = await ref.read(inMemoryOrderRepositoryProvider.notifier).getAllPayments();
    final initialPayIds = paymentFixtures.map((p) => p.id).toSet();
    final deltaPayments = allPayments.where((p) => !initialPayIds.contains(p.id));

    final allExpenses = ref.read(inMemoryExpenseRepositoryProvider);
    final initialExpIds = expenseFixtures.map((e) => e.id).toSet();
    final deltaExpenses = allExpenses.where((e) => !initialExpIds.contains(e.id));

    final allSavings = ref.read(inMemorySavingsRepositoryProvider);
    final initialSavIds = savingsFixtures.map((s) => s.id).toSet();
    final deltaSavings = allSavings.where((s) => !initialSavIds.contains(s.id));

    final totals = buildReport(
      baseline: baseline,
      orders: deltaOrders,
      payments: deltaPayments,
      expenses: deltaExpenses,
      savings: deltaSavings,
      range: range,
    );
    state = totals;
    return totals;
  }

  @override
  Future<List<ServiceRevenue>> getTopServices(ReportRange range) async => weekTopServicesFixtures;
}

final inMemoryReportRepositoryProvider = NotifierProvider<InMemoryReportRepository, ReportTotals>(
  InMemoryReportRepository.new,
);
