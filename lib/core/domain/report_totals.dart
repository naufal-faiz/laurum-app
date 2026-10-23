import 'package:equatable/equatable.dart';

class ReportTotals extends Equatable {
  const ReportTotals({
    this.revenue = 0,
    this.transactionCount = 0,
    this.expenses = 0,
    this.cashIn = 0,
    this.activeOutstanding = 0,
    this.savingsBalance = 0,
    this.cashFromOrders = 0,
    this.savingsUsed = 0,
    this.newOutstanding = 0,
  });
  final int revenue, transactionCount, expenses, cashIn, activeOutstanding, savingsBalance;
  final int cashFromOrders, savingsUsed, newOutstanding;
  int get profit => revenue - expenses;
  @override
  List<Object?> get props => [
    revenue,
    transactionCount,
    expenses,
    cashIn,
    activeOutstanding,
    savingsBalance,
    cashFromOrders,
    savingsUsed,
    newOutstanding,
  ];
}
