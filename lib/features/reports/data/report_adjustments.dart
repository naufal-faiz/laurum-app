import 'package:laurum/core/domain/report_totals.dart';

// Rebuild a historical baseline by replacing its known fixture contribution.
ReportTotals adjustReport(ReportTotals base, ReportTotals initial, ReportTotals current) =>
    ReportTotals(
      revenue: base.revenue - initial.revenue + current.revenue,
      transactionCount: base.transactionCount - initial.transactionCount + current.transactionCount,
      expenses: base.expenses - initial.expenses + current.expenses,
      cashIn: base.cashIn - initial.cashIn + current.cashIn,
      activeOutstanding:
          base.activeOutstanding - initial.activeOutstanding + current.activeOutstanding,
      savingsBalance: base.savingsBalance - initial.savingsBalance + current.savingsBalance,
      cashFromOrders: base.cashFromOrders - initial.cashFromOrders + current.cashFromOrders,
      savingsUsed: base.savingsUsed - initial.savingsUsed + current.savingsUsed,
      newOutstanding: base.newOutstanding - initial.newOutstanding + current.newOutstanding,
    );
