import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerSavingsFilter extends Notifier<int> {
  CustomerSavingsFilter(this.customerId);
  final String customerId;

  @override
  int build() => 0;
  void select(int value) => state = value;
}

final customerSavingsFilterProvider = NotifierProvider.family<CustomerSavingsFilter, int, String>(
  CustomerSavingsFilter.new,
);
