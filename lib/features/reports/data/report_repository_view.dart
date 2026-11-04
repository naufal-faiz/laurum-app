import 'package:laurum/core/domain/report_baseline.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/report_totals.dart';
import 'package:laurum/core/domain/repositories/report_repository.dart';
import 'package:laurum/core/domain/service_revenue.dart';

// A new view publishes derived-store changes through normal provider rebuilds.
class ReportRepositoryView implements ReportRepository {
  const ReportRepositoryView(this.source);
  final ReportRepository source;
  @override
  Future<ReportTotals> getReport(ReportRange range) => source.getReport(range);
  @override
  Future<ReportBaseline> getBaseline(ReportRange range) => source.getBaseline(range);
  @override
  Future<List<ServiceRevenue>> getTopServices(ReportRange range) => source.getTopServices(range);
}
