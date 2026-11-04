import 'package:laurum/core/domain/report.dart';
import 'package:laurum/core/domain/report_daily.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/report_totals.dart';
import 'package:laurum/core/domain/top_services.dart';
import 'package:laurum/features/customers/data/savings_fixtures.dart';
import 'package:laurum/features/expenses/data/expense_fixtures.dart';
import 'package:laurum/features/orders/data/order_fixtures.dart';
import 'package:laurum/features/orders/data/order_item_fixtures.dart';
import 'package:laurum/features/orders/data/payment_fixtures.dart';
import 'package:laurum/features/reports/data/report_ranges.dart';

export 'package:laurum/features/reports/data/report_ranges.dart';

// Gallery/test samples are derived from DATA MASTER ledgers, never added to reports.
ReportTotals fixtureReport(ReportRange range) => buildReport(
  range: range,
  orders: orderFixtures,
  payments: paymentFixtures,
  expenses: expenseFixtures,
  savings: savingsFixtures,
);
final todayReportSample = fixtureReport(todayRange);
final weekReportSample = fixtureReport(weekRange);
final monthReportSample = fixtureReport(monthRange);
final weekTopServicesSamples = topServices(orderFixtures, orderItemFixtures, range: weekRange);
final weekDailyRevenueSample = <int?>[
  ...dailyRevenue(weekRange, orderFixtures).take(5),
  null,
  null,
];
