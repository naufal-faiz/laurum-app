import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerOrderExpansion extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void showAll(String customerId) => state = {...state, customerId};
}

final customerOrderExpansionProvider = NotifierProvider<CustomerOrderExpansion, Set<String>>(
  CustomerOrderExpansion.new,
);
