import 'package:laurum/core/domain/report_baseline.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/report_totals.dart';
import 'package:laurum/core/domain/service_revenue.dart';

abstract class ReportRepository {
  Future<ReportTotals> getReport(ReportRange range);
  Future<ReportBaseline> getBaseline(ReportRange range);
  Future<List<ServiceRevenue>> getTopServices(ReportRange range);
}
