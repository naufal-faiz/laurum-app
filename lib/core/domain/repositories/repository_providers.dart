import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/repositories/business_repository.dart';
import 'package:laurum/core/domain/repositories/customer_repository.dart';
import 'package:laurum/core/domain/repositories/expense_repository.dart';
import 'package:laurum/core/domain/repositories/order_repository.dart';
import 'package:laurum/core/domain/repositories/proposal_repository.dart';
import 'package:laurum/core/domain/repositories/report_repository.dart';
import 'package:laurum/core/domain/repositories/savings_repository.dart';
import 'package:laurum/core/domain/repositories/service_repository.dart';

final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  throw UnimplementedError('businessRepositoryProvider not initialized');
});

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  throw UnimplementedError('customerRepositoryProvider not initialized');
});

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  throw UnimplementedError('serviceRepositoryProvider not initialized');
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  throw UnimplementedError('orderRepositoryProvider not initialized');
});

final savingsRepositoryProvider = Provider<SavingsRepository>((ref) {
  throw UnimplementedError('savingsRepositoryProvider not initialized');
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  throw UnimplementedError('expenseRepositoryProvider not initialized');
});

final proposalRepositoryProvider = Provider<ProposalRepository>((ref) {
  throw UnimplementedError('proposalRepositoryProvider not initialized');
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  throw UnimplementedError('reportRepositoryProvider not initialized');
});
