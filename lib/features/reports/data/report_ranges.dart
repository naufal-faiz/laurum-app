import 'package:laurum/core/domain/report_range.dart';

// DATA MASTER sample ranges; runtime ranges come from reportPeriodRange.
final todayRange = ReportRange(DateTime(2026, 10, 16), DateTime(2026, 10, 17));
final weekRange = ReportRange(DateTime(2026, 10, 12), DateTime(2026, 10, 19));
final monthRange = ReportRange(DateTime(2026, 10), DateTime(2026, 11));
