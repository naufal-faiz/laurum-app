import 'package:equatable/equatable.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/report_totals.dart';

// Historical summary for exactly this range. Inputs to buildReport must not
// overlap it. To change an order summarized here, rebuild the baseline first.
class ReportBaseline extends Equatable {
  const ReportBaseline({required this.range, this.totals = const ReportTotals()});
  final ReportRange range;
  final ReportTotals totals;
  @override
  List<Object?> get props => [range, totals];
}
