import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/report.dart';
import 'package:laurum/core/domain/report_daily.dart';
import 'package:laurum/core/domain/report_positions.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/report_totals.dart';
import 'package:laurum/core/domain/repositories/report_repository.dart';
import 'package:laurum/core/domain/service_revenue.dart';
import 'package:laurum/core/domain/top_services.dart';
import 'package:laurum/features/customers/data/in_memory_savings_repository.dart';
import 'package:laurum/features/expenses/data/in_memory_expense_repository.dart';
import 'package:laurum/features/orders/data/in_memory_order_repository.dart';
import 'package:laurum/features/reports/data/report_ranges.dart';

class InMemoryReportRepository extends Notifier<ReportTotals> implements ReportRepository {
  ReportTotals _report(ReportRange range) {
    final orders = ref.read(inMemoryOrderRepositoryProvider);
    return buildReport(
      range: range,
      orders: orders.orders,
      payments: orders.payments,
      expenses: ref.read(inMemoryExpenseRepositoryProvider),
      savings: ref.read(inMemorySavingsRepositoryProvider),
    );
  }

  @override
  ReportTotals build() {
    ref.watch(inMemoryOrderRepositoryProvider);
    ref.watch(inMemoryExpenseRepositoryProvider);
    ref.watch(inMemorySavingsRepositoryProvider);
    return _report(weekRange);
  }

  @override
  bool updateShouldNotify(ReportTotals previous, ReportTotals next) => true;
  @override
  Future<ReportTotals> getReport(ReportRange range) async => _report(range);
  @override
  Future<List<ServiceRevenue>> getTopServices(ReportRange range) async {
    final store = ref.read(inMemoryOrderRepositoryProvider);
    return topServices(store.orders, store.items, range: range);
  }

  @override
  Future<int> getUnpaidCount() async {
    final store = ref.read(inMemoryOrderRepositoryProvider);
    return ledgerPositions(
      store.orders,
      store.payments,
      ref.read(inMemorySavingsRepositoryProvider),
    ).unpaidCount;
  }

  @override
  Future<List<int>> getDailyRevenue(ReportRange range) async =>
      dailyRevenue(range, ref.read(inMemoryOrderRepositoryProvider).orders);
}

final inMemoryReportRepositoryProvider = NotifierProvider<InMemoryReportRepository, ReportTotals>(
  InMemoryReportRepository.new,
);
