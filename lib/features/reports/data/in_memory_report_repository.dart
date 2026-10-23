import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:laurum/features/orders/data/order_item_fixtures.dart';
import 'package:laurum/features/orders/data/order_store.dart';
import 'package:laurum/features/orders/data/payment_fixtures.dart';
import 'package:laurum/features/reports/data/report_adjustments.dart';
import 'package:laurum/features/reports/data/report_fixtures.dart';
import 'package:laurum/features/reports/data/report_snapshot.dart';
import 'package:laurum/features/reports/data/report_top_services.dart';

class InMemoryReportRepository extends Notifier<ReportTotals> implements ReportRepository {
  final _initialOrders = OrderStore(
    orders: orderFixtures,
    items: orderItemFixtures,
    payments: paymentFixtures,
    events: [],
  );

  ReportTotals _report(ReportRange range) => adjustReport(
    _baseline(range).totals,
    reportSnapshot(range, _initialOrders, expenseFixtures, savingsFixtures),
    reportSnapshot(
      range,
      ref.read(inMemoryOrderRepositoryProvider),
      ref.read(inMemoryExpenseRepositoryProvider),
      ref.read(inMemorySavingsRepositoryProvider),
    ),
  );

  ReportBaseline _baseline(ReportRange range) {
    if (range == todayRange) return todayBaseline;
    if (range == weekRange) return weekBaseline;
    if (range == monthRange) return monthBaseline;
    throw UnsupportedError('Dummy baseline exists only for today, week and month');
  }

  @override
  ReportTotals build() {
    ref.watch(inMemoryOrderRepositoryProvider);
    ref.watch(inMemoryExpenseRepositoryProvider);
    ref.watch(inMemorySavingsRepositoryProvider);
    return _report(weekRange);
  }

  // Items/events can change without changing weekly totals, but affect queries.
  @override
  bool updateShouldNotify(ReportTotals previous, ReportTotals next) => true;

  @override
  Future<ReportBaseline> getBaseline(ReportRange range) async => _baseline(range);

  @override
  Future<ReportTotals> getReport(ReportRange range) async => _report(range);

  @override
  Future<List<ServiceRevenue>> getTopServices(ReportRange range) async {
    if (range != weekRange) {
      throw UnsupportedError('Dummy top-service baseline exists only for this week');
    }
    return adjustedTopServices(_initialOrders, ref.read(inMemoryOrderRepositoryProvider), range);
  }
}

final inMemoryReportRepositoryProvider = NotifierProvider<InMemoryReportRepository, ReportTotals>(
  InMemoryReportRepository.new,
);
