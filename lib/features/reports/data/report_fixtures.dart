import 'package:laurum/core/domain/report_baseline.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/domain/report_totals.dart';
import 'package:laurum/core/domain/service_revenue.dart';

final todayRange = ReportRange(DateTime(2026, 10, 16), DateTime(2026, 10, 17));
final weekRange = ReportRange(DateTime(2026, 10, 12), DateTime(2026, 10, 19));
final monthRange = ReportRange(DateTime(2026, 10), DateTime(2026, 11));

final todayBaseline = ReportBaseline(
  range: todayRange,
  totals: const ReportTotals(
    revenue: 375000,
    transactionCount: 12,
    expenses: 145000,
    cashIn: 343500,
    activeOutstanding: 400500,
    savingsBalance: 430000,
    cashFromOrders: 328500,
    newOutstanding: 46500,
  ),
);

final weekBaseline = ReportBaseline(
  range: weekRange,
  totals: const ReportTotals(
    revenue: 1800000,
    transactionCount: 58,
    expenses: 850000,
    cashIn: 1699500,
    activeOutstanding: 400500,
    savingsBalance: 430000,
    cashFromOrders: 1574500,
    savingsUsed: 25000,
    newOutstanding: 200500,
  ),
);

final monthBaseline = ReportBaseline(
  range: monthRange,
  totals: const ReportTotals(
    revenue: 4250000,
    transactionCount: 135,
    expenses: 1850000,
    cashIn: 4050000,
    activeOutstanding: 400500,
    savingsBalance: 430000,
    cashFromOrders: 3750000,
    savingsUsed: 99500,
    newOutstanding: 400500,
  ),
);

final weekTopServicesFixtures = <ServiceRevenue>[
  const ServiceRevenue(
    serviceId: 'srv-003',
    serviceName: 'Cuci setrika',
    unit: 'kg',
    qtyMilli: 98000,
    revenue: 882000,
  ),
  const ServiceRevenue(
    serviceId: 'srv-002',
    serviceName: 'Cuci kiloan',
    unit: 'kg',
    qtyMilli: 70000,
    revenue: 490000,
  ),
  const ServiceRevenue(
    serviceId: 'srv-004',
    serviceName: 'Bed cover',
    unit: 'pcs',
    qtyMilli: 14000,
    revenue: 350000,
  ),
  const ServiceRevenue(
    serviceId: 'other',
    serviceName: 'Lainnya',
    unit: '',
    qtyMilli: 0,
    revenue: 78000,
  ),
];
