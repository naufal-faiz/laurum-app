import 'package:laurum/core/domain/report.dart';
import 'package:laurum/core/domain/report_daily.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/report_totals.dart';
import 'package:laurum/core/domain/repositories/report_repository.dart';
import 'package:laurum/core/domain/service_revenue.dart';
import 'package:laurum/core/domain/top_services.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/features/expenses/data/expense_queries.dart';
import 'package:laurum/features/orders/data/order_range_queries.dart';
import 'package:laurum/features/reports/data/report_positions_sql.dart';
import 'package:laurum/features/reports/data/report_range_queries.dart';

class DriftReportRepository implements ReportRepository {
  DriftReportRepository(this.db, this.ownerId);
  final AppDatabase db;
  final String ownerId;
  @override
  Future<ReportTotals> getReport(ReportRange range) => db.transaction(() async {
    return buildReport(
      range: range,
      orders: await readOrders(db, ownerId, range: range),
      payments: await reportPayments(db, ownerId, range),
      expenses: await readExpenses(db, ownerId, from: range.start, to: range.end),
      savings: await reportDeposits(db, ownerId, range),
      positions: await readReportPositions(db, ownerId),
    );
  });
  @override
  Future<int> getUnpaidCount() async => (await readReportPositions(db, ownerId)).unpaidCount;
  @override
  Future<List<int>> getDailyRevenue(ReportRange range) async =>
      dailyRevenue(range, await readOrders(db, ownerId, range: range));
  @override
  Future<List<ServiceRevenue>> getTopServices(ReportRange range) => db.transaction(
    () async => topServices(
      await readOrders(db, ownerId, range: range),
      await reportItems(db, ownerId, range),
      range: range,
    ),
  );
}
